--[[

Author: tochonement
Email: tochonement@gmail.com

13.05.2021

--]]

whoi.load = {}

local load = whoi.load

function load.server(path)
    if SERVER then
        return include(path)
    end
end

function load.client(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        return include(path)
    end
end

function load.shared(path)
    if SERVER then
        AddCSLuaFile(path)
        return load.server(path)
    else
        return load.client(path)
    end
end

function load.auto(path)
    local prefix = string.match(path, "/(%l+)_")

    if prefix then
        if prefix == "sv" then
            return load.server(path)
        elseif prefix == "cl" then
            return load.client(path)
        elseif prefix == "sh" then
            return load.shared(path)
        end
    else
        error("No prefix found")
    end
end