--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.webicon = whoi.webicon or {}
whoi.webicon.cache = whoi.webicon.cache or {}
whoi.webicon.queue = whoi.webicon.queue or {}

local webicon = whoi.webicon
local dirName = "webicons"
local basePath = dirName .. "/"

if not file.Exists(dirName, "DATA") then
    file.CreateDir(dirName)
end

function webicon.getName(url)
    local crc = util.CRC(url)
    local format = string.match(url, ".%w+$")

    return crc .. format
end

function webicon.findInQueue(name)
    for index, data in ipairs(webicon.queue) do
        if (data.name == name) then
            return data, index
        end
    end
end

function webicon.create(url, parameters)
    local name = webicon.getName(url)
    local successToLoad = webicon.load(name, parameters)
    local foundInQueue = webicon.findInQueue(name)

    if not successToLoad and not foundInQueue then
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
    end, function(error)
        if failCallback then
            failCallback(error)
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
        end, function(error)
            print("Failed to load: ", url, "\n", error)
        end)
    end
end)