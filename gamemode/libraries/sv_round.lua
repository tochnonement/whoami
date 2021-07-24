--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.round = whoi.round or {}

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

local function isReadyToStartRound()
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

    round.setGuesser(nextGuesser)
    round.setWisher(makingWish)
    round.setState(whoi.state.PREPARING)

    print("Guesser: ", nextGuesser)
    print("Wisher: ",  makingWish)

    -- Send to a wisher menu, where he can choose a word
    netez.send(makingWish, "ChooseWordMenu", choices)

    timer.Create("PickRandomWord", 15, 1, function()
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
    local word = whoi.word.get(wordId)

    netez.send(respondents, "Notification", "Word chosen: " .. word:GetName(), 0, 2)
    netez.send(round.wisher, "CloseWordSelectionMenu")

    round.setState(whoi.state.STARTED)

    timer.Remove("PickRandomWord")
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

function round.finish()
    timer.Remove("PickRandomWord")

    round.setGuesser(nil)
    round.setWisher(nil)
    round.setState(whoi.state.IDLE)
end

timer.Create("whoi.round.AutoStart", 1, 0, function()
    if round.getState() == whoi.state.IDLE then
        if isReadyToStartRound() then
            round.start()
        end
    end
end)