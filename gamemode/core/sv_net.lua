--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

netez.register("SelectWord")
:AddField("string")
:SetDelay(1)
:SetCallback(function(ply, wordId)
    local word = whoi.word.get(wordId)

    if (whoi.round.getState() == whoi.state.PREPARING) and (whoi.round.getWisher() == ply) and word then
        whoi.round.selectWord(wordId)
        whoi.util.print(ply:Name() .. " selected word: " .. word.id)
    end
end)

netez.register("SelectModel")
:AddField("uint")
:SetDelay(1)
:SetCallback(function(ply, index)
    local modelPath = whoi.config.models[index]

    if modelPath then
        ply:SetModel(modelPath)

        whoi.util.print(ply:Name() .. " changed his model to " .. modelPath)
        whoi.util.notify(ply, "YouChangedModel", 0, 2)
    end
end)

netez.register("Vote")
:SetDelay(1)
:SetCallback(function(ply)
    if (whoi.round.getGuesser() ~= ply) then
        local bool = whoi.round.addVote(ply)
        if bool then
            whoi.util.notify(ply, "YouVoted", 0, 2)
        else
            whoi.util.notify(ply, "YouAlreadyVoted", 1, 2)
        end
    end
end)