--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.word = whoi.word or {}
whoi.word.storage = whoi.word.storage or {}

local word = whoi.word

-- ANCHOR Meta table

local WORD = {}
WORD.__index = WORD

whoi.util.accessor(WORD, "name")
whoi.util.accessor(WORD, "category")
whoi.util.accessor(WORD, "imageUrl")

function WORD:GetID()
    return self.id
end

function WORD:Translate(langId, translate)
    if CLIENT then
        whoi.lang.addPhrase(langId, self.id, translate)
    end

    return self
end

function WORD:SetName(name)
    if CLIENT then
        whoi.lang.addPhrase("english", self.id, name)
    end

    self.name = name

    return self
end

if CLIENT then
    function WORD:PrepareImage()
        local url = self:GetImageUrl()
        local webIconId

        if url then
            webIconId = whoi.webicon.create(url, "smooth mips")
        else
            webIconId = whoi.webicon.create("https://i.imgur.com/HuyqvUd.png", "smooth mips")
        end

        self.image = webIconId

        return webIconId
    end

    function WORD:GetName()
        return L(self.id)
    end

    function WORD:GetCategory()
        return L(self.category)
    end
end

-- ANCHOR Functions

function word.register(id)
    local object = setmetatable({}, WORD)

    object.id = id

    word.storage[id] = object

    return object
end

function word.get(id)
    return word.storage[id]
end

function word.load()
    local gamemodePacksPath = GM.FolderName .. "/gamemode/config/packs/"
    local addonPacksPath = "whoami_packs/"
    local gamemodePacks = file.Find(gamemodePacksPath .. "*", "LUA")
    local addonPacks = file.Find(addonPacksPath .. "*", "LUA")
    local customAddedCount = 0

    for _, v in ipairs(addonPacks) do
        whoi.load.shared(addonPacksPath .. v)
        whoi.util.print("Loaded pack: " .. v)

        customAddedCount = customAddedCount + 1
    end

    if customAddedCount == 0 then
        whoi.util.print("No custom packs found, loading default ones...")

        for _, v in ipairs(gamemodePacks) do
            whoi.load.shared(gamemodePacksPath .. v)
            whoi.util.print("Loaded pack: " .. v)
        end

        if SERVER then
            local prefixText = "(WHOI) "
            local link = "https://steamcommunity.com/workshop/filedetails/?id=2557061945"

            hook.Add("PlayerNetworkReady", "whoi.NotifyThatNoPacks", function(ply)
                ply:ChatPrint(prefixText .. " No custom word packs found, using default ones...")
                ply:ChatPrint(prefixText .. " Check official word packs:")
                ply:ChatPrint(link)
            end)
        end
    end
end

function word.count()
    return table.Count(word.storage)
end

function word.getRandom(count)
    local storage = word.storage
    local result = {}

    if table.Count(storage) < count then
        error("You're trying to get too many words, this count doesn't exist")
        return false
    end

    repeat
        local randomWord = table.Random(storage)
        local randomWordID = randomWord.id

        for _, id in ipairs(result) do
            if id == randomWordID then
                goto skip
            end
        end

        table.insert(result, randomWordID)

        ::skip::
    until (#result == count)

    return result
end