--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local colorBg = Color(230, 206, 156)
local colorOutline = Color(143, 116, 45)
local outlineStrength = 3

PANEL = {}

function PANEL:Init()
    self.divCircle = self:Add("Panel")

    self.divTitle = self:Add("Panel")

    self.lblTitle = self.divTitle:Add("DLabel")
    self.lblTitle:SetTextColor(color_black)
    self.lblTitle:SetFont("DermaLarge")
    self.lblTitle:SetContentAlignment(5)
end

function PANEL:PerformLayout(w, h)
    self.divCircle:Dock(FILL)

    self.divTitle:Dock(BOTTOM)
    self.divTitle:SetTall(h * .2)

    self.lblTitle:Dock(TOP)

    local radius = self.divCircle:GetWide() * 0.33
    if radius >= 1 then
        self.circle = whoi.circle.new(CIRCLE_FILLED, radius, (self.divCircle:GetWide() / 2), (self.divCircle:GetTall() / 2), 5)
    end
end

function PANEL:Paint(w, h)
    local circle = self.circle

    draw.RoundedBox(16, 0, 0, w, h, colorOutline)
    draw.RoundedBox(16, outlineStrength, outlineStrength, w - (outlineStrength * 2), h - (outlineStrength * 2), colorBg)

    draw.NoTexture()
    surface.SetDrawColor(colorOutline)
    circle()

    if self.webIconName then
        local radius = circle:GetRadius()

        whoi.webicon.draw(self.webIconName, circle:GetX() - radius / 2, circle:GetY() - radius / 2, radius, radius)
    end
end

function PANEL:SetWord(id)
    local word = whoi.word.get(id)

    if word then
        local image = word:GetImage()

        self.word = word

        self.lblTitle:SetText(word:GetName())
        self.lblTitle:SizeToContentsY()

        if image then
            self.webIconName = whoi.webicon.create(image, "smooth mips")
        end
    end
end

function PANEL:Show()
    local w, h = self:GetSize()

    self.animStarted = true
    self.animProgress = 0
    self:SetSize(0, 0)
    self:Center()
    self.target = {
        w = w,
        h = h
    }
end

function PANEL:Think()
    if self.animStarted then
        local speed = FrameTime() * 3
        local w = self.target.w
        local h = self.target.h

        self.animProgress = Lerp(speed, self.animProgress, 1)

        self:SetSize(w * self.animProgress, h * self.animProgress)
        self:Center()
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