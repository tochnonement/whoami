--[[

Author: tochonement
Email: tochonement@gmail.com

14.07.2021

--]]

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

function GM:PlayerInitialSpawn(ply)
    ply:SetTeam(TEAM_PLAYER)
    ply:SetNoCollideWithTeammates(true)
end

function GM:PlayerSpawn(ply)
    local model = table.Random(whoi.config.models)

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