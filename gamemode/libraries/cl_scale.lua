--[[

Author: tochonement
Email: tochonement@gmail.com

14.07.2021

--]]

whoi.scale = whoi.scale or {}
whoi.scale.cache = whoi.scale.cache or {}

local scale = whoi.scale

---Function to scale and cache width
---@param value number
---@param reference number
---@return number
function scale.width(value, reference)
    local key = "w" .. value .. "/" .. reference
    local stored = scale.cache[key]

    if stored then
        return stored
    else
        reference = reference or 1600

        local new = value / reference * ScrW()

        scale.cache[key] = new

        return new
    end
end

---Function to scale and cache height
---@param value number
---@param reference number
---@return number
function scale.height(value, reference)
    local key = "h" .. value .. "/" .. reference
    local stored = scale.cache[key]

    if stored then
        return stored
    else
        reference = reference or 900

        local new = value / reference * ScrH()

        scale.cache[key] = new

        return new
    end
end

---Function to store object, which depends on resolution (for example circle)
---@param key string
---@param func function
---@return any
function scale.store(key, func)
    if scale.storage[key] then
        return scale.storage[key]
    else
        local object = func()

        scale.storage[key] = object

        return object
    end
end

hook.Add("OnScreenSizeChanged", "whoi.scale.Reset", function()
    scale.cache = {}
end)