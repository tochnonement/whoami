--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local logo = whoi.webicon.create("https://i.imgur.com/TSrMR5J.png", "smooth mips")

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function GM:HUDPaint()
    local scrw, scrh = ScrW(), ScrH()
    local size = whoi.scale.height(96)
    local mat = whoi.webicon.get(logo)

    if mat then
        surface.SetMaterial(mat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(scrw - size, size, size, size, math.sin(CurTime() * 1) * 45)
    end
end

function GM:HUDShouldDraw(name)
    if hide[name] then
        return false
    end

    return true
end