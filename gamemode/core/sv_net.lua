--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

netez.register("SelectWord")
:AddField("string")
:SetDelay(1)
:SetCallback(function(ply, wordId)
    if (whoi.round.getWisher() == ply) and whoi.word.get(wordId) then
        whoi.round.selectWord(wordId)
    end
end)