--[[

Author: tochonement
Email: tochonement@gmail.com

26.07.2021

--]]

-- ANCHOR "whoi.Tutorial"

-- Taken from https://github.com/NebulousCloud/helix/blob/ff41fe48126b891b6484acc3622dee83cf18e824/gamemode/core/sh_util.lua
local function wrapText(text, maxWidth, font)
    surface.SetFont(font)

    local words = string.Explode("%s", text, true)
    local lines = {}
    local line = ""

    -- we don't need to calculate wrapping if we're under the max width
    if (surface.GetTextSize(text) <= maxWidth) then
        return {text}
    end

    for i = 1, #words do
        local word = words[i]
        local wordWidth = surface.GetTextSize(word)

        -- this word is very long so we have to split it by character
        if (wordWidth > maxWidth) then
            local newWidth

            for i2 = 1, string.len(word) do
                local character = word[i2]
                newWidth = surface.GetTextSize(line .. character)

                -- if current line + next character is too wide, we'll shove the next character onto the next line
                if (newWidth > maxWidth) then
                    lines[#lines + 1] = line
                    line = ""
                end

                line = line .. character
            end

            continue
        end

        local newLine = line .. " " .. word
        local newWidth = surface.GetTextSize(newLine)

        if (newWidth > maxWidth) then
            -- adding this word will bring us over the max width
            lines[#lines + 1] = line

            line = word
        else
            -- otherwise we tack on the new word and continue
            line = newLine
        end
    end

    if (line != "") then
        lines[#lines + 1] = line
    end

    return lines
end

PANEL = {}

function PANEL:Init()
    self:SetTitle(L"Tutorial")

    self.list = self:Add("DScrollPanel")

    self.btnWorkshop = self:Add("DButton")
    self.btnWorkshop:SetText(L"OpenWorkshop")
    self.btnWorkshop.DoClick = function()
        steamworks.ViewFile("2557006893")
    end
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)

    self.list:Dock(FILL)
    self.list:InvalidateParent(true)

    self.btnWorkshop:Dock(BOTTOM)
end

function PANEL:LoadTabs()
    self:AddInfo(L"TutorialWhatIsItTitle", L"TutorialWhatIsIt")
    self:AddInfo(L"TutorialGameplayTitle", L"TutorialGameplay")
end

function PANEL:AddInfo(title, text)
    text = string.Trim(text)

    local lblTitle = self.list:Add("DLabel")
    lblTitle:SetText(title)
    lblTitle:SetTextColor(color_black)
    lblTitle:SetFont(whoi.font.create("Roboto Bk@24"))
    lblTitle:Dock(TOP)
    lblTitle:DockMargin(0, 0, 0, 5)

    local content = self.list:Add("Panel")
    content.text = text
    content.font = whoi.font.create("Roboto@20")
    content.shadow = false
    content.textColor = color_black
    content.WrapText = function(panel)
        assert(panel.text)
        assert(panel.font)

        panel.wrapped = wrapText(panel.text, self.list:GetWide(), panel.font)
    end
    content.GetCharHeight = function(panel)
        surface.SetFont(panel.font)
        local _, charHeight = surface.GetTextSize("A")

        return charHeight
    end
    content.GetNiceTall = function(panel)
        if panel.wrapped then
            local charHeight = panel:GetCharHeight()
            local totalHeight = #panel.wrapped * charHeight

            panel.charHeight = charHeight

            return totalHeight
        end
    end
    content.PerformLayout = function(panel, w, h)
        panel:WrapText()
    end
    content.Paint = function(panel, w, h)
        local x = 0
        local y = 0
        local charHeight = panel.charHeight or 16
        local textColor = content.textColor or color_white

        for _, str in ipairs(panel.wrapped) do
            str = string.Trim(str)

            if panel.shadow then
                whoi.util.shadowText(str, panel.font, x, y, textColor, 0, 0)
            else
                draw.SimpleText(str, panel.font, x, y, textColor, 0, 0)
            end

            y = y + charHeight
        end
    end

    content:WrapText()
    content:SetTall(content:GetNiceTall())
    content:Dock(TOP)
    content:DockMargin(0, 0, 0, 5)
end

vgui.Register("whoi.Tutorial", PANEL, "whoi.Frame")

-- ANCHOR Function

function whoi.openTutorial()
    local frame = vgui.Create("whoi.Tutorial")
    frame:SetSize(ScrW() * 0.3, ScrH() * 0.5)
    frame:Center()
    frame:MakePopup()
    frame:LoadTabs()
end

-- ANCHOR Test

-- if DebugPanel and IsValid(DebugPanel) then
--     DebugPanel:Remove()
-- end

-- DebugPanel = vgui.Create("whoi.Tutorial")
-- DebugPanel:SetSize(ScrW() * 0.3, ScrH() * 0.5)
-- DebugPanel:Center()
-- DebugPanel:MakePopup()
-- DebugPanel:LoadTabs()