--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

whoi.round = whoi.round or {}

local round = whoi.round

function round.getRespondents()
    local result = {}

    for _, ply in ipairs(player.GetAll()) do
        if round.getGuesser() ~= ply then
            table.insert(result, ply)
        end
    end

    return result
end

function round.getGuesser()
    return whoi.netvar.getGlobal("guesser")
end

function round.getWisher()
    return whoi.netvar.getGlobal("wisher")
end

function round.getState()
    return whoi.netvar.getGlobal("roundState", whoi.state.IDLE)
end