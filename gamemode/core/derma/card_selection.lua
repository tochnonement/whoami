--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

PANEL = {}

function PANEL:Init()
    self.lblTitle = self:Add("DLabel")
    self.lblTitle:SetText(L("ChooseWord"))
    self.lblTitle:SetExpensiveShadow(1, ColorAlpha(color_black, 200))
    self.lblTitle:SetFont(whoi.font.create("Roboto@48"))
    self.lblTitle:SetTextColor(color_white)
    self.lblTitle:SetContentAlignment(5)
    self.lblTitle:SizeToContentsY()

    self.lblTimer = self:Add("DLabel")
    self.lblTimer:SetText("")
    self.lblTimer:SetExpensiveShadow(1, ColorAlpha(color_black, 200))
    self.lblTimer:SetFont(whoi.font.create("Roboto Bk@36"))
    self.lblTimer:SetTextColor(color_white)
    self.lblTimer:SetContentAlignment(8)
    self.lblTimer.Think = function(panel)
        local endTime = self.endTime

        if endTime then
            local remain = endTime - CurTime()

            panel:SetText(string.FormattedTime(remain, "%02i:%02i:%02i"))
        end
    end

    self.cards = {}
end

function PANEL:PerformLayout(w, h)
    self.lblTitle:Dock(TOP)
    self.lblTitle:SetTall(h * 0.1)

    self.lblTimer:Dock(TOP)
    self.lblTimer:SetTall(h * 0.1)
end

function PANEL:Paint(w, h)
    whoi.blur.simple(5)

    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:AddCard(word)
    local card = self:Add("whoi.WordCard")
    card:SetWord(word)
    card.button.DoClick = function()
        self:OnCardSelected(card.word.id)
    end

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

function PANEL:StartTimer(time)
    self.endTime = CurTime() + time
end

function PANEL:OnCardSelected(id)
    
end

vgui.Register("whoi.CardSelection", PANEL)

-- ANCHOR Test

-- if DebugPanel and IsValid(DebugPanel) then
--     DebugPanel:Remove()
-- end

-- local choices = whoi.word.getRandom(3)

-- DebugPanel = vgui.Create("whoi.CardSelection")
-- DebugPanel:SetSize(ScrW(), ScrH())
-- DebugPanel:MakePopup()
-- DebugPanel:AddCard(choices[1])
-- DebugPanel:AddCard(choices[2])
-- DebugPanel:AddCard(choices[3])
-- DebugPanel:StartTimer(15)