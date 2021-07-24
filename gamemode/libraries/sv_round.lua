--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.round = whoi.round or {}
whoi.round.votes = whoi.round.votes or {}

local round = whoi.round

local function getRandomExceptOne(tbl, exception)
    local filtered = {}

    for _, item in ipairs(tbl) do
        if item ~= exception then
            table.insert(filtered, item)
        end
    end

    if not table.IsEmpty(filtered) then
        return table.Random(filtered)
    end
end

local function checkReadyToContinue()
    local allowed = hook.Run("whoi.CanStartRound")

    if #whoi.netvar.getReadyPlayers() < 2 then
        return false
    end

    if allowed == false then
        return false
    end

    return true
end

function round.start()
    local queue = whoi.playersQueue

    -- Get the next player, who wil guess and remove him from queue
    local nextGuesser = queue:Pop()
    -- Get a random player, who will wish a word for guesser
    local makingWish = getRandomExceptOne(queue:Items(), nextGuesser)
    -- Get three random choices
    local choices = whoi.word.getRandom(3)
    local choiceTime = 15

    round.setGuesser(nextGuesser)
    round.setWisher(makingWish)
    round.setVotes(0)
    round.setState(whoi.state.PREPARING)

    whoi.util.print("Guesser: ", nextGuesser:Name())
    whoi.util.print("Wisher: ", makingWish:Name())

    -- Send to a wisher menu, where he can choose a word
    netez.send(makingWish, "ChooseWordMenu", choices, choiceTime)

    timer.Create("whoi.PickRandomWord", choiceTime, 1, function()
        local choice = whoi.word.getRandom(1)[1]
        round.selectWord(choice)
    end)

    -- Insert the player back to the end of queue
    queue:Push(nextGuesser)

    hook.Run("whoi.OnRoundStarted")

    return true
end

function round.selectWord(wordId)
    local respondents = round.getRespondents()

    netez.send(respondents, "SendWordToRespondents", wordId)
    netez.send(round.getWisher(), "CloseWordSelectionMenu")

    round.word = whoi.word.get(wordId)

    round.setState(whoi.state.STARTED)
    round.startTimer(300)

    timer.Remove("whoi.PickRandomWord")
end

function round.setState(state)
    return whoi.netvar.setGlobal("roundState", state)
end

function round.setWisher(ply)
    whoi.netvar.setGlobal("wisher", ply)
end

function round.setGuesser(ply)
    whoi.netvar.setGlobal("guesser", ply)
end

function round.setVotes(count)
    whoi.netvar.setGlobal("voteCount", count)
end

function round.addVote(ply)
    local count = round.getVotes()
    local votes = round.votes
    local new = count + 1

    if not votes[ply] then
        round.setVotes(new)

        votes[ply] = true

        hook.Run("whoi.VoteCountChanged", new)

        return true
    end

    return false
end

function round.startTimer(time)
    whoi.netvar.setGlobal("roundEndTime", CurTime() + time)

    timer.Create("whoi.AutoFinish", time, 1, function()
        round.finish()
    end)
end

function round.finish()
    timer.Remove("whoi.PickRandomWord")
    timer.Remove("whoi.AutoFinish")

    -- Just to exclude any issues
    netez.send(round.getWisher(), "CloseWordSelectionMenu")

    round.setGuesser(nil)
    round.setWisher(nil)
    round.setState(whoi.state.IDLE)

    round.votes = {}
end

hook.Add("PlayerDisconnected", "whoi.round.Check", function(ply)
    if round.getGuesser() == ply then
        round.finish()
        whoi.util.print("Round finished, because guesser has left")
    end
end)

hook.Add("whoi.VoteCountChanged", "whoi.round.Check", function(new)
    if new == round.getRequiredVoteCount() then
        round.finish()
    end
end)

timer.Create("whoi.round.Controller", 1, 0, function()
    local isReadyToContinue = checkReadyToContinue()

    if round.getState() == whoi.state.IDLE then
        if isReadyToContinue then
            round.start()

            whoi.util.print("Round auto-started!")
        end
    else
        if not isReadyToContinue then
            round.finish()

            whoi.util.print("Round auto-finished, because conditions are not met!")
        end
    end
end)

-- round.finish()