--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local colorBg = whoi.colors.main
local colorOutline = whoi.colors.outline
local colorHighlight = Color(241, 196, 15)
local outlineStrength = 3

PANEL = {}

function PANEL:Init()
    self.divCircle = self:Add("Panel")

    self.divTitle = self:Add("Panel")

    self.lblTitle = self.divTitle:Add("DLabel")
    self.lblTitle:SetTextColor(color_black)
    self.lblTitle:SetFont(whoi.font.create("Roboto Bk@32"))
    self.lblTitle:SetContentAlignment(5)

    self.lblCategory = self.divTitle:Add("DLabel")
    self.lblCategory:SetTextColor(color_black)
    self.lblCategory:SetFont(whoi.font.create("Roboto@20"))
    self.lblCategory:SetContentAlignment(5)

    self.button = self:Add("DButton")
    self.button:SetText("")
    self.button.Paint = nil
    self.button.Think = function(panel)
        self.hovered = panel:IsHovered()
    end
end

function PANEL:PerformLayout(w, h)
    self.divCircle:Dock(FILL)

    self.divTitle:Dock(BOTTOM)
    self.divTitle:SetTall(h * .2)

    self.lblTitle:Dock(TOP)
    self.lblCategory:Dock(TOP)

    self.button:SetSize(w, h)

    local radius = self.divCircle:GetWide() * 0.33
    if radius >= 1 then
        self.circle = whoi.circle.new(CIRCLE_FILLED, radius, (self.divCircle:GetWide() / 2), (self.divCircle:GetTall() / 2), 5)
    end
end

function PANEL:Paint(w, h)
    local circle = self.circle

    draw.RoundedBox(16, 0, 0, w, h, colorOutline)
    draw.RoundedBox(16, outlineStrength, outlineStrength, w - (outlineStrength * 2), h - (outlineStrength * 2), colorBg)

    if self.hovered then
        draw.RoundedBox(16, outlineStrength, outlineStrength, w - (outlineStrength * 2), h - (outlineStrength * 2), ColorAlpha(colorHighlight, math.abs(math.sin(CurTime() * 3)) * 200))
    end

    draw.NoTexture()
    surface.SetDrawColor(colorOutline)
    circle()

    if self.webIconId then
        local radius = circle:GetRadius()

        whoi.webicon.draw(self.webIconId, circle:GetX() - radius / 2, circle:GetY() - radius / 2, radius, radius)
    end
end

function PANEL:SetWord(id)
    local word = whoi.word.get(id)

    if word then
        self.word = word

        self.lblTitle:SetText(word:GetName())
        self.lblTitle:SizeToContentsY()

        self.lblCategory:SetText(word:GetCategory())
        self.lblCategory:SizeToContentsY()

        self.webIconId = word:PrepareImage()
    end
end

function PANEL:Show()
    local w, h = self:GetSize()
    local x0, y0 = self:GetPos()

    x0 = x0 + w / 2
    y0 = y0 + h / 2

    self.animStarted = true
    self.animProgress = 0
    self:SetSize(0, 0)
    self:Center()
    self.target = {
        w = w,
        h = h,
        x0 = x0,
        y0 = y0
    }
end

function PANEL:Think()
    if self.animStarted then
        local speed = FrameTime() * 3
        local w = self.target.w
        local h = self.target.h
        local x0 = self.target.x0
        local y0 = self.target.y0

        self.animProgress = Lerp(speed, self.animProgress, 1)

        self:SetSize(w * self.animProgress, h * self.animProgress)
        self:SetPos(x0 - self:GetWide() / 2, y0 - self:GetTall() / 2)
    end
end

vgui.Register("whoi.WordCard", PANEL)

-- ANCHOR Test

-- if DebugPanel and IsValid(DebugPanel) then
--     DebugPanel:Remove()
-- end

-- DebugPanel = vgui.Create("whoi.WordCard")
-- DebugPanel:SetSize(ScrW() * 0.175, ScrH() * 0.5)
-- DebugPanel:Center()
-- DebugPanel:SetWord("carrot")
-- DebugPanel:Show()