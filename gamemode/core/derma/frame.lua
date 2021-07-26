--[[

Author: tochonement
Email: tochonement@gmail.com

26.07.2021

--]]

local baseClass = baseclass.Get("DFrame")

PANEL = {}

function PANEL:Init()
    self:DockPadding(10, 35, 10, 10)
    self:ShowCloseButton(false)

    self.lblTitle:SetFont(whoi.font.create("Roboto@18"))
    self.lblTitle:SetExpensiveShadow(1, ColorAlpha(color_black, 200))

    self.btnClose2 = self:Add("DButton")
    self.btnClose2:SetText("X")
    self.btnClose2:SetFont(whoi.font.create("Roboto@18"))
    self.btnClose2:SetTextColor(color_white)
    self.btnClose2:SetExpensiveShadow(1, ColorAlpha(color_black, 200))
    self.btnClose2.Paint = nil
    self.btnClose2.DoClick = function()
        self:Close()
    end
end

function PANEL:PerformLayout(w, h)
    baseClass.PerformLayout(self, w, h)

    self.lblTitle:SetTall(h * 0.055)

    local lblHeight = self.lblTitle:GetTall()

    self.btnClose2:SetSize(lblHeight, lblHeight)
    self.btnClose2:SetPos(w - lblHeight, 0)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, whoi.colors.outline)
    draw.RoundedBox(8, 2, 2, w - 4, h - 4, whoi.colors.main)

    draw.RoundedBoxEx(8, 2, 2, w - 4, self.lblTitle:GetTall(), whoi.colors.outline)
end

vgui.Register("whoi.Frame", PANEL, "DFrame")