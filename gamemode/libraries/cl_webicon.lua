--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.webicon = whoi.webicon or {}
whoi.webicon.cache = whoi.webicon.cache or {}
whoi.webicon.queue = whoi.webicon.queue or {}

local webicon = whoi.webicon
local basePath = "webicons/"

function webicon.getName(url)
    local crc = util.CRC(url)
    local format = string.match(url, ".%w+$")

    return crc .. format
end

function webicon.create(url, parameters)
    local name = webicon.getName(url)
    local successToLoad = webicon.load(name, parameters)

    if not successToLoad then
        table.insert(webicon.queue, {
            url = url,
            name = name,
            parameters = parameters
        })
    end

    return name
end

function webicon.download(url, name, successCallback, failCallback)
    http.Fetch(url, function(body)
        file.Write(basePath .. name, body)

        if successCallback then
            successCallback()
        end
    end, function()
        if failCallback then
            failCallback()
        end
    end)
end

function webicon.load(name, parameters)
    if webicon.cache[name] then
        return true
    end

    local path = "data/" .. basePath .. name

    if file.Exists(path, "GAME") then
        webicon.cache[name] = Material(path, parameters)

        return true
    end

    return false
end

function webicon.get(name)
    return webicon.cache[name]
end

function webicon.draw(name, x, y, w, h)
    local material = webicon.get(name)
    if material then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(x, y, w, h)
    end
end

timer.Create("whoi.webicon.ProcessQueue", 0.2, 0, function()
    if not table.IsEmpty(webicon.queue) then
        local data = table.remove(webicon.queue, 1)
        local url = data.url
        local name = data.name

        webicon.download(url, name, function()
            webicon.load(name, data.parameters)
        end, function()
            print("Failed to load: " .. url)
        end)
    end
end)