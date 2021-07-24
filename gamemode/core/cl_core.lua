--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

whoi.bind.add("Vote", KEY_F1, BIND_RELEASE, function(self, pressed)
    if not pressed then
        print("HELLO")
    end
end)

whoi.bind.add("OpenModelMenu", KEY_F2, BIND_RELEASE, function(self, pressed)
    if not pressed then 
        local frame = vgui.Create("whoi.ModelSelection")
        frame:SetSize(ScrW() * 0.3, ScrH() * 0.5)
        frame:Center()
        frame:MakePopup()
        frame:LoadModels()
    end
end)