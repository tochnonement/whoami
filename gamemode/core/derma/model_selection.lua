--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

local PANEL = {}

function PANEL:Init()
    self.list = self:Add("DIconLayout")
    self.list:SetSpaceX(5)
    self.list:SetSpaceY(5)

    self:SetTitle(L("OpenModelMenu"))
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
    self.BaseClass.PerformLayout(self, w, h)

    self.lblTitle:SetTall(h * 0.055)

    local lblHeight = self.lblTitle:GetTall()

    self.list:Dock(FILL)

    self.btnClose2:SetSize(lblHeight, lblHeight)
    self.btnClose2:SetPos(w - lblHeight, 0)

    local count = 7
    local children = self.list:GetChildren()
    local cell_wide = (self.list:GetWide() - ((count - 1) * 5)) / count
    for _, item in ipairs(children) do
        item:SetSize(cell_wide, cell_wide)
    end

    self.list:Layout()
    self.list:InvalidateLayout()
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, whoi.colors.outline)
    draw.RoundedBox(8, 2, 2, w - 4, h - 4, whoi.colors.main)

    draw.RoundedBoxEx(8, 2, 2, w - 4, self.lblTitle:GetTall(), whoi.colors.outline)
end

function PANEL:LoadModels()
    for index, modelPath in ipairs(whoi.config.models) do
        local model = self.list:Add("SpawnIcon")
        model:SetModel(modelPath)
        model.Paint = function(panel, w, h)
            surface.SetDrawColor(whoi.colors.outline)
            surface.DrawRect(0, 0, w, h)
        end
        model.DoClick = function(panel)
            netez.send("SelectModel", index)
        end
    end
end

vgui.Register("whoi.ModelSelection", PANEL, "DFrame")

-- ANCHOR Test

-- if DebugPanel and IsValid(DebugPanel) then
--     DebugPanel:Remove()
-- end

-- DebugPanel = vgui.Create("whoi.ModelSelection")
-- DebugPanel:SetSize(ScrW() * 0.3, ScrH() * 0.5)
-- DebugPanel:Center()
-- DebugPanel:MakePopup()
-- DebugPanel:LoadModels()