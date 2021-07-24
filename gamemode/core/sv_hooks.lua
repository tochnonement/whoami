--[[

Author: tochonement
Email: tochonement@gmail.com

14.07.2021

--]]

local models = {
    "models/player/Group01/male_01.mdl",
    "models/player/Group01/male_02.mdl",
    "models/player/Group01/male_03.mdl",
    "models/player/Group01/male_04.mdl",
    "models/player/Group01/male_05.mdl",
    "models/player/Group01/male_06.mdl",
    "models/player/Group01/male_07.mdl",
    "models/player/Group01/male_08.mdl",
    "models/player/Group01/male_09.mdl"
}

function GM:PlayerNetworkReady(ply)
    whoi.playersQueue:Push(ply)
    whoi.util.print("New player added to queue: " .. ply:Name())
end

function GM:PlayerDisconnected(ply)
    local queue = whoi.playersQueue

    for index, member in ipairs(queue:Items()) do
        if member == ply then
            queue:Remove(index)
            whoi.util.print("Player removed from queue: " .. ply:Name())
            break
        end
    end
end

function GM:PlayerSpawn(ply)
    local model = table.Random(models)

    ply:SetModel(model)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(250)
    ply:SetHealth(100)
    ply:SetArmor(0)

    ply:SetupHands()
end

function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)

    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end