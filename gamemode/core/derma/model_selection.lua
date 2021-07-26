--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

PANEL = {}

function PANEL:Init()
    self.list = self:Add("DIconLayout")
    self.list:SetSpaceX(5)
    self.list:SetSpaceY(5)

    self:SetTitle(L("OpenModelMenu"))
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)

    local count = 7
    local children = self.list:GetChildren()
    local cell_wide = (self.list:GetWide() - ((count - 1) * 5)) / count
    for _, item in ipairs(children) do
        item:SetSize(cell_wide, cell_wide)
    end

    self.list:Dock(FILL)
    self.list:Layout()
    self.list:InvalidateLayout()
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

vgui.Register("whoi.ModelSelection", PANEL, "whoi.Frame")

-- ANCHOR Test

-- if DebugPanel and IsValid(DebugPanel) then
--     DebugPanel:Remove()
-- end

-- DebugPanel = vgui.Create("whoi.ModelSelection")
-- DebugPanel:SetSize(ScrW() * 0.3, ScrH() * 0.5)
-- DebugPanel:Center()
-- DebugPanel:MakePopup()
-- DebugPanel:LoadModels()