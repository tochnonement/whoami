--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.round = whoi.round or {}
whoi.round.state = {
    NOT_ENOUGH_PLAYERS = 1,
    WORD_CHOOSING = 2,
    STARTED = 3
}
whoi.round.errors = {
    notEnoughPlayers = 1
}

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

function round.start()
    local queue = whoi.playersQueue

    -- We cannot start round with one player
    if queue:Count() < 2 then
        return false, round.errors.notEnoughPlayers
    end

    -- Get the next player, who wil guess and remove him from queue
    local nextGuesser = queue:Pop()
    -- Get a random player, who will wish a word for guesser
    local makingWish = getRandomExceptOne(queue:Items(), nextGuesser)
    -- Get three random choices
    local choices = whoi.word.getRandom(3)

    whoi.round.guesser = nextGuesser
    whoi.round.wisher = makingWish

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

    timer.Remove("PickRandomWord")
end

function round.getRespondents()
    local result = {}

    for _, ply in ipairs(player.GetAll()) do
        if whoi.round.guesser ~= ply then
            table.insert(result, ply)
        end
    end

    return result
end

function round.finish()
    timer.Remove("PickRandomWord")
end

hook.Add("PlayerNetworkReady", "whoi.round.AutoStart", function()
    if player.GetCount() > 1 then
        round.start()
    end
end)