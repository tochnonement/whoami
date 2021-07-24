--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

local CATEGORY = "Creatures"

if CLIENT then
    whoi.lang.addPhrase("russian", CATEGORY, "Монстры")
end

whoi.word.register("goblin")
:SetCategory(CATEGORY)
:SetName("Goblin")
:SetImageUrl("https://i.imgur.com/7GIIezt.png")
:Translate("russian", "Гоблин")

whoi.word.register("dragon")
:SetCategory(CATEGORY)
:SetName("Dragon")
:SetImageUrl("https://i.imgur.com/Gbh2ryN.png")
:Translate("russian", "Дракон")

whoi.word.register("dwarf")
:SetCategory(CATEGORY)
:SetName("Dwarf")
:SetImageUrl("https://i.imgur.com/XwYBMcj.png")
:Translate("russian", "Гном")

whoi.word.register("cyclops")
:SetCategory(CATEGORY)
:SetName("Cyclops")
:SetImageUrl("https://i.imgur.com/biAyhG4.png")
:Translate("russian", "Циклоп")

whoi.word.register("vampire")
:SetCategory(CATEGORY)
:SetName("Vampire")
:SetImageUrl("https://i.imgur.com/AU0Qkqb.png")
:Translate("russian", "Вампир")

whoi.word.register("zombie")
:SetCategory(CATEGORY)
:SetName("Zombie")
:SetImageUrl("https://i.imgur.com/7gfchU3.png")
:Translate("russian", "Зомби")