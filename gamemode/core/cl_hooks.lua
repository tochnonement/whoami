--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local colorGueeser = Color(225, 177, 44)
local logo = whoi.webicon.create("https://i.imgur.com/TSrMR5J.png", "smooth mips")

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function GM:HUDPaint()
    local scrw, scrh = ScrW(), ScrH()

    -- Logo
    local logoSize = whoi.scale.height(96)
    local logoMat = whoi.webicon.get(logo)

    if logoMat then
        surface.SetMaterial(logoMat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(scrw - logoSize, logoSize, logoSize, logoSize, math.sin(CurTime() * 1) * 45)
    end

    -- Status
    local roundState = whoi.round.getState()
    local statusText

    if roundState == whoi.state.IDLE then
        statusText = "Waiting for players"
    elseif roundState == whoi.state.PREPARING then
        local wisher = whoi.round.getWisher()
        if IsValid(wisher) then
            statusText = whoi.round.getWisher():Name() .. " is picking a word"
        else
            statusText = "Wisher has leaved, word will be picked randomly"
        end
    else
        local st = string.FormattedTime(whoi.round.getRemainTime(), "%02i:%02i:%02i")
        local m = string.match(st, "%d+")
        local s = string.match(st, ":%d+")

        statusText = m .. s
    end

    if statusText then
        whoi.util.shadowText(statusText, whoi.font.create("Roboto@48"), scrw / 2, logoSize, color_white, 1, 1, 2)
    end

    -- Who is guesser
    local guesser = whoi.round.getGuesser()
    local word = whoi.round.word
    local iconSize = whoi.scale.height(64)

    if IsValid(guesser) then
        local x = logoSize / 2

        if LocalPlayer() ~= guesser then
            if word then
                word:PrepareImage()

                local webIconId = word.image
                local space = whoi.scale.width(25)

                whoi.webicon.draw(webIconId, x, logoSize - iconSize / 2, iconSize, iconSize)

                x = x + iconSize + space

                local textX = whoi.util.shadowText(guesser:Name(), whoi.font.create("Roboto Bk@36"), x, logoSize, color_white, 0, 1)

                x = x + textX

                whoi.util.shadowText(" (" .. word:GetName() .. ")", whoi.font.create("Roboto@36"), x, logoSize, color_white, 0, 1)
            end
        else
            whoi.util.shadowText("You are guessing", whoi.font.create("Roboto@36"), x, logoSize, color_white, 0, 1)
        end
    end
end

function GM:PostPlayerDraw(ply)
    local eyeAng = EyeAngles()
    local boneID = ply:LookupBone("ValveBiped.Bip01_Head1")
    local boneMatrix = ply:GetBoneMatrix(boneID)
    local pos = boneMatrix:GetTranslation() + Vector(0, 0, 16)
    local ang = Angle(0, eyeAng.y - 90, 90)

    local guesser = whoi.round.getGuesser()
    local word = whoi.round.word

    cam.Start3D2D(pos, ang, 0.1)
        local color = color_white
        local text = ply:Name()

        if IsValid(guesser) and guesser == ply then
            color = colorGueeser
        end

        whoi.util.shadowText(text, whoi.font.create("Roboto Bk@64"), 0, 0, color, 1, 1)
    cam.End3D2D()
end

function GM:HUDShouldDraw(name)
    if hide[name] then
        return false
    end

    return true
end

timer.Create("whoi.MusicLoop", 1, 0, function()
    local music = whoi.music

    if music and IsValid(music) then
        if music:GetState() ~= GMOD_CHANNEL_PLAYING then
            music:Play()
        end
    else
        sound.PlayFile("sound/whoi/music.mp3", "noplay", function(station, error)
            if IsValid(station) then
                station:SetVolume(0.1)
                station:Play()

                whoi.music = station
            end
        end)
    end
end)