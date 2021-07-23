--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function GM:HUDPaint()
end

function GM:HUDShouldDraw(name)
    if hide[name] then
        return false
    end

    return true
end