--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.round = whoi.round or {}
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

    -- Send to a wisher menu, where he can choose a word
    netez.send(makingWish, "ChooseWordMenu", choices)

    -- Insert the player back to the end of queue
    queue:Push(nextGuesser)

    hook.Run("whoi.OnRoundStarted")

    return true
end

function round.finish()
    
end