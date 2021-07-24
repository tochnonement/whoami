--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

whoi.lang = whoi.lang or {}
whoi.lang.reference = whoi.lang.reference or {}
whoi.lang.storage = whoi.lang.storage or {}
whoi.lang.phrases = whoi.lang.phrases or {}

local lang = whoi.lang
local basePath = GM.FolderName .. "/gamemode/languages/"
local referenceLanguage = "english"

local function getPath(id)
    return basePath .. id .. ".lua"
end

if CLIENT then
    local languageReference = {
        en = "english",
        ru = "russian",
        uk = "russian",
        de = "german",
        fr = "french",
        it = "italian"
    }

    function lang.load(id)
        local path = getPath(id)

        if id ~= "english" and file.Exists(path, "LUA") then
            lang.storage = include(path)
        end

        lang.current = id
    end

    function lang.get(id, args)
        local refPhrases = lang.phrases[referenceLanguage] or {}
        local phrases = lang.phrases[lang.current] or {}
        local storage = lang.storage
        local reference = lang.reference
        local text

        -- Search in an added phrases' table
        if phrases[id] then
            text = phrases[id]
        end

        -- Search in a localized language table
        if not text and storage[id] then
            text = storage[id]
        end

        -- Search in a reference language table
        if not text and reference[id] then
            text = reference[id]
        end

        -- Search in a reference phrases' table
        if not text and refPhrases[id] then
            text = refPhrases[id]
        end

        -- Parse args to found string
        if args then
            for key, value in pairs(args) do
                if isentity(value) and value:IsPlayer() then
                    if IsValid(value) then
                        text = string.gsub(text, "{" .. key .. "}", value:Name(), 1)
                    end
                else
                    text = string.gsub(text, "{" .. key .. "}", tostring(value), 1)
                end
            end
        end

        return text
    end

    function lang.addPhrase(langId, id, text)
        lang.phrases[langId] = lang.phrases[langId] or {}
        lang.phrases[langId][id] = text
    end

    function lang.getBestLanguage()
        local current = GetConVar("gmod_language"):GetString()

        return languageReference[current]
    end

    function lang.tryToSetBestLanguage()
        local best = lang.getBestLanguage()

        if best then
            lang.load(best)
        end
    end

    cvars.AddChangeCallback("gmod_language", function(name, old, new)
        lang.tryToSetBestLanguage()
    end)

    _G["L"] = lang.get
end

function lang.init()
    if SERVER then
        local languages = file.Find(basePath .. "*", "LUA")

        for _, v in ipairs(languages) do
            AddCSLuaFile(basePath .. v)
        end
    else
        whoi.lang.reference = include(getPath(referenceLanguage))

        lang.tryToSetBestLanguage()
    end
end