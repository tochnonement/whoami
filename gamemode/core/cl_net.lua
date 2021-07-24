--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

netez.register("Notification")
:AddField("string")
:AddField("uint")
:AddField("uint")
:SetCallback(function(text, type, length)
    notification.AddLegacy(text, type, length)
end)

netez.register("ChooseWordMenu")
:AddField("table")
:AddField("uint")
:SetCallback(function(choices, choiceTime)
    local fr = vgui.Create("whoi.CardSelection")
    fr:SetSize(ScrW(), ScrH())
    fr:MakePopup()
    fr:StartTimer(choiceTime)
    fr.OnCardSelected = function(panel, id)
        netez.send("SelectWord", id)
    end

    for _, id in ipairs(choices) do
        fr:AddCard(id)
    end
end)

netez.register("CloseWordSelectionMenu"):SetCallback(function()
    whoi.util.findPanel("whoi.CardSelection", function(panel)
        panel:Remove()
    end)
end)

netez.register("SendWordToRespondents")
:AddField("string")
:SetCallback(function(wordId)
    whoi.round.word = whoi.word.get(wordId)
end)