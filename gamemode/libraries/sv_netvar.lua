--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

whoi.netvar = whoi.netvar or {}
whoi.netvar.private = whoi.netvar.private or {}
whoi.netvar.public = whoi.netvar.public or {}
whoi.netvar.global = whoi.netvar.global or {}

local netvar = whoi.netvar

local function syncAll(ply)
    for key, value in pairs(netvar.global or {}) do
        netez.send(ply, "netvar:SetGlobal", key, value)
    end

    for key, value in pairs(netvar.private[ply] or {}) do
        netez.send(ply, "netvar:Set", ply, key, value)
    end

    for ent, data in pairs(netvar.public) do
        if IsValid(ent) then
            for key, value in pairs(data) do
                netez.send(ply, "netvar:Set", ent, key, value)
            end
        end
    end
end

function netvar.setGlobal(key, value)
    netvar.global[key] = value

    netez.send(nil, "netvar:SetGlobal", key, value)
end

function netvar.getGlobal(key, fallback)
    local value = netvar.global[key]

    if value ~= nil then
        return value
    end

    return fallback
end

function ENTITY:GetNetVar(key, fallback)
    local publicStorage = netvar.public[self]
    local privateStorage = netvar.private[self]

    if self:IsPlayer() and privateStorage and privateStorage[key] ~= nil then
        return privateStorage[key]
    end

    if publicStorage and publicStorage[key] ~= nil then
        return publicStorage[key]
    end

    return fallback
end

function ENTITY:SetNetVar(key, value)
    netvar.public[self] = netvar.public[self] or {}
    netvar.public[self][key] = value

    netez.send(nil, "netvar:Set", self, key, value)
end

function PLAYER:SetLocalVar(key, value)
    netvar.private[self] = netvar.private[self] or {}
    netvar.private[self][key] = value

    netez.send(self, "netvar:Set", self, key, value)
end

do
    local function get_hook_name(ply)
        return ("whoi.netvar.Check_" .. ply:SteamID64())
    end

    hook.Add("PlayerInitialSpawn", "whoi.netvar.GetNetworkReady", function(ply)
        hook.Add("SetupMove", get_hook_name(ply), function(ply2, mvd, cmd)
            if ply == ply2 and not cmd:IsForced() then
                hook.Run("PlayerNetworkReady", ply2)
                hook.Remove("SetupMove", get_hook_name(ply2))
            end
        end)
    end)
end

hook.Add("PlayerNetworkReady", "whoi.netvar.Sync", function(ply)
    syncAll(ply)
end)

hook.Add("EntityRemoved", "whoi.netvar.Clear", function(ent)
    netvar.public[ent] = nil
end)

hook.Add("PlayerDisconnected", "whoi.netvar.Clear", function(ply)
    netvar.private[ply] = nil
end)