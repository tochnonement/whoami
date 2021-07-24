--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

local ENTITY = FindMetaTable("Entity")

whoi.netvar = whoi.netvar or {}
whoi.netvar.data = whoi.netvar.data or {}
whoi.netvar.global = whoi.netvar.global or {}

local netvar = whoi.netvar

function netvar.getGlobal(key, fallback)
    local value = netvar.global[key]

    if value ~= nil then
        return value
    end

    return fallback
end

function ENTITY:GetNetVar(key, fallback)
    local storage = netvar.data[self]

    if storage[key] ~= nil then
        return storage[key]
    end

    return fallback
end

function GetLocalVar(key)
    return LocalPlayer():GetNetVar(key)
end

netez.register("netvar:SetGlobal")
:AddField("string")
:AddField("any")
:SetCallback(function(key, value)
    netvar.global[key] = value
end)

netez.register("netvar:Set")
:AddField("entity")
:AddField("string")
:AddField("any")
:SetCallback(function(ent, key, value)
    netvar.data[ent] = netvar.data[ent] or {}
    netvar.data[ent][key] = value
end)

hook.Add("EntityRemoved", "whoi.netvar.Clear", function(ent)
    netvar.data[ent] = nil
end)