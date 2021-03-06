--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

local CATEGORY = "Vegetables"

if CLIENT then
    whoi.lang.addPhrase("russian", CATEGORY, "Овощи")
end

whoi.word.register("cucumber")
:SetCategory(CATEGORY)
:SetName("Cucumber")
:SetImageUrl("https://i.imgur.com/8tf1krV.png")
:Translate("russian", "Огурец")
:Translate("french", "Concombre")
:Translate("german", "Gurke")

whoi.word.register("tomato")
:SetCategory(CATEGORY)
:SetName("Tomato")
:SetImageUrl("https://i.imgur.com/keSNb94.png")
:Translate("russian", "Помидор")
:Translate("french", "Tomate")
:Translate("german", "Tomate")

whoi.word.register("carrot")
:SetCategory(CATEGORY)
:SetName("Carrot")
:SetImageUrl("https://i.imgur.com/WGBr4dK.png")
:Translate("russian", "Морковь")
:Translate("french", "Carotte")
:Translate("german", "Möhren")

whoi.word.register("potato")
:SetCategory(CATEGORY)
:SetName("Potato")
:SetImageUrl("https://i.imgur.com/Ym4qOZB.png")
:Translate("russian", "Картошка")
:Translate("french", "Patate")
:Translate("german", "Kartoffel")