--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

local CATEGORY = "Fruits"

if CLIENT then
    whoi.lang.addPhrase("russian", CATEGORY, "Фрукты")
end

whoi.word.register("banana")
:SetCategory(CATEGORY)
:SetName("Banana")
:SetImageUrl("https://i.imgur.com/5YlW1dt.png")
:Translate("russian", "Банан")

whoi.word.register("apple")
:SetCategory(CATEGORY)
:SetName("Apple")
:SetImageUrl("https://i.imgur.com/tCpygPE.png")
:Translate("russian", "Яблоко")

whoi.word.register("orange")
:SetCategory(CATEGORY)
:SetName("Orange")
:SetImageUrl("https://i.imgur.com/b6Eqk6r.png")
:Translate("russian", "Мандарин")

whoi.word.register("watermelon")
:SetCategory(CATEGORY)
:SetName("Watermelon")
:SetImageUrl("https://i.imgur.com/8jZxN4f.png")
:Translate("russian", "Арбуз")