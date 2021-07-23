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

function GM:PostPlayerDraw(ply)
    local eyeAng = EyeAngles()
    local boneID = ply:LookupBone("ValveBiped.Bip01_Head1")
    local boneMatrix = ply:GetBoneMatrix(boneID)
    local pos = boneMatrix:GetTranslation() + Vector(0, 0, 16)
    local ang = Angle(0, eyeAng.y - 90, 90)

    cam.Start3D2D(pos, ang, 0.15)
        draw.SimpleText(ply:Name(), "DermaLarge", 0, 0, color_white, 1, 1)
    cam.End3D2D()
end

function GM:HUDShouldDraw(name)
    if hide[name] then
        return false
    end

    return true
end