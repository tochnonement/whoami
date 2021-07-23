--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

whoi.font = whoi.font or {}
whoi.font.storage = whoi.font.storage or {}

local fontNameTemplate = "whoi.%s.%i"

function whoi.font.create(pattern, size, noScaling)
    local family

    if size then
        family = pattern
    else
        family, size = unpack(string.Explode("@", pattern))
    end

    local name = fontNameTemplate:format(family, size)

    size = tonumber(size)

    if whoi.font.get(name) then
        return name
    end

    if not noScaling then
        size = size / 900 * ScrH()
    end

    surface.CreateFont(name, {
        font = family,
        size = size,
        extended = true
    })

    whoi.font.storage[name] = true

    return name
end

function whoi.font.get(name)
    return whoi.font.storage[name]
end

hook.Add("OnScreenSizeChanged", "whoi.font.Reset", function()
    whoi.font.storage = {}
end)