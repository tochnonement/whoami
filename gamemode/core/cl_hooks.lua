--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local colorGueeser = Color(225, 177, 44)
local colorHint = Color(249, 202, 36)
local logo = whoi.webicon.create("https://i.imgur.com/TSrMR5J.png", "smooth mips")

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function GM:HUDPaint()
    local scrw, scrh = ScrW(), ScrH()
    local guesser = whoi.round.getGuesser()
    local isLocalGuesser = IsValid(guesser) and guesser == LocalPlayer() or false
    local logoSize = whoi.scale.height(96)
    local logoMat = whoi.webicon.get(logo)

    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, logoSize * 0.75, scrw, logoSize / 2)

    -- Logo
    if logoMat then
        surface.SetMaterial(logoMat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(scrw - logoSize, logoSize, logoSize, logoSize, math.sin(CurTime() * 1) * 45)
    end

    -- Status
    local roundState = whoi.round.getState()
    local statusText

    if roundState == whoi.state.IDLE then
        statusText = L("WaitingForPlayers")
    elseif roundState == whoi.state.PREPARING then
        local wisher = whoi.round.getWisher()
        if IsValid(wisher) then
            statusText = L("IsPickingWord", {player = wisher})
        end
    else
        local st = string.FormattedTime(whoi.round.getRemainTime(), "%02i:%02i:%02i")
        local m = string.match(st, "%d+")
        local s = string.match(st, ":%d+")

        whoi.util.shadowText(m .. s, whoi.font.create("Roboto@48"), scrw / 2, logoSize, color_white, 1, 1, 2)
    end

    if statusText then
        whoi.util.shadowText(statusText, whoi.font.create("Roboto@48"), scrw / 2, logoSize, color_white, 1, 1, 2)
    end

    -- Who is guesser
    local word = whoi.round.word
    local iconSize = whoi.scale.height(64)
    local baseX = logoSize / 2

    if IsValid(guesser) then
        local x = baseX
        if not isLocalGuesser then
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
            whoi.util.shadowText(L("YouGuessing"), whoi.font.create("Roboto@36"), x, logoSize, color_white, 0, 1)
        end
    end

    local keySize = whoi.scale.height(48)
    local y = logoSize * 0.75 + logoSize / 2 + keySize * 2
    local text = whoi.round.getVotes() .. "/" .. whoi.round.getRequiredVoteCount()

    if roundState == whoi.state.STARTED then
        whoi.util.shadowText(L("Votes") .. ": " .. text, whoi.font.create("Roboto Condensed@24"), scrw - baseX, y, color_white, 2, 1)
    end


    -- Binds
    for _, bind in pairs(whoi.bind.getSortedTable()) do
        if bind.id == "Vote" and (isLocalGuesser or whoi.round.getState() ~= whoi.state.STARTED) then
            goto skip
        end

        whoi.util.drawKey(baseX + keySize / 2, y, keySize, input.GetKeyName(bind.button))
        whoi.util.shadowText(L(bind.id), whoi.font.create("Roboto Condensed@24"), baseX + keySize + 5, y, color_white, 0, 1)

        y = y + keySize + 5

        ::skip::
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

hook.Add("PostGamemodeLoaded", "whoi.StartMusicLoopTimer", function()
    timer.Create("whoi.MusicLoop", 1, 0, function()
        local music = whoi.music

        if IsValid(music) then
            if music:GetState() ~= GMOD_CHANNEL_PLAYING then
                music:Play()
            end
        else
            sound.PlayFile("sound/whoami/music.mp3", "noplay", function(station, error)
                if IsValid(station) then
                    whoi.music = station

                    station:SetVolume(0.1)
                    station:Play()
                end
            end)
        end
    end)
end)
