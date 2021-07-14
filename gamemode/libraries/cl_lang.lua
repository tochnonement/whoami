--[[

Author: tochonement
Email: tochonement@gmail.com

29.03.2021

--]]

local languages_path = GM.FolderName .. "/gamemode/languages/"

whoi.lang = whoi.lang or {}
whoi.lang.phrases = whoi.lang.phrases or {}
whoi.lang.backup = include(languages_path .. "english.lua")

local lang = whoi.lang

function lang.get(id, args)
    local text
    local current = lang.current
    local current_id = lang.current_id or "english"
    local phrases = lang.phrases[current_id]

    -- Search in local language table
    if current and current[id] then
        text = current[id]
    end

    -- Search in added by plugins and etc. phrases' table
    if phrases and phrases[id] then
        text = phrases[id]
    end

    if current_id then
        if phrases and lang.phrases["english"][id] then
            text = lang.phrases["english"][id]
        end
    end

    -- Search in backup language table
    if not text then
        text = lang.backup[id]

        if not text then
            return id
        end
    end

    for key, value in pairs(args or {}) do
        if isplayer(value) then
            if IsValid(value) then
                text = string.gsub(text, "{" .. key .. "}", value:Name(), 1)
            end
        else
            text = string.gsub(text, "{" .. key .. "}", tostring(value), 1)
        end
    end

    return text
end

function lang.add(language, id, text)
    if not lang.phrases[language] then
        lang.phrases[language] = {}
    end

    lang.phrases[language][id] = text
end

function lang.get_clean(id)
    local text = lang.current and lang.current[id]

    if not text then
        text = lang.backup[id]

        if not text then
            return id
        end
    end

    return text
end

function lang.parse(str, ...)
    local first = str[1]
    local text = str

    if first and first == "?" then
        text = lang.get(str:sub(2), ...)
    end

    return text
end

function lang.load(id)
    if id == "english" then
        lang.phrases = {}
        return
    end

    local path = languages_path .. id .. ".lua"
    local exists = file.Exists(path, "LUA")

    if exists then
        lang.current_id = id
        lang.current = include(path)

        hook.Run("whoi.LanguageLoaded", id)

        whoi.debug.print("Language successfuly loaded: " .. id)
    else
        whoi.debug.error("Language wasn't found (" .. id .. ")")
    end
end

function lang.init()
    for _, f in ipairs(file.Find(languages_path .. "*", "LUA")) do
        AddCSLuaFile(languages_path .. f)
    end
end

L = lang.get