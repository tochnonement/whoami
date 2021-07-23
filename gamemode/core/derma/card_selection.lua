--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

PANEL = {}

function PANEL:Init()
    self.cards = {}
end

function PANEL:Paint(w, h)
    whoi.blur.simple(5)

    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:AddCard(word)
    local card = self:Add("whoi.WordCard")
    card:SetWord(word)

    table.insert(self.cards, card)

    self:UpdateCards()
end

function PANEL:UpdateCards()
    local x0, y0 = ScrW() / 2, ScrH() / 2
    local w, h = self:GetSize()
    local cardW, cardH = w * 0.17, h * 0.5
    local cardCount = #self.cards
    local x, y = x0 - (cardCount * (cardW + 10)) / 2, y0 - cardH / 2

    for _, card in ipairs(self.cards) do
        card:SetSize(cardW, cardH)
        card:SetPos(x, y)
        card:Show()

        x = x + cardW + 5
    end
end

vgui.Register("whoi.CardSelection", PANEL)

-- ANCHOR Test

if DebugPanel and IsValid(DebugPanel) then
    DebugPanel:Remove()
end

DebugPanel = vgui.Create("whoi.CardSelection")
DebugPanel:SetSize(ScrW(), ScrH())
DebugPanel:MakePopup()
DebugPanel:AddCard("cucumber")
DebugPanel:AddCard("tomato")
DebugPanel:AddCard("carrot")