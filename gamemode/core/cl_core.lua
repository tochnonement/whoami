--[[

Author: tochonement
Email: tochonement@gmail.com

24.07.2021

--]]

whoi.bind.add("Vote", KEY_F1, BIND_RELEASE, function(self, pressed)
    if not pressed then
        netez.send("Vote")
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

whoi.bind.add("OpenTutorial", KEY_F3, BIND_RELEASE, function(self, pressed)
    if not pressed then 
        whoi.openTutorial()
    end
end)

-- Show tutorial to player if he never played this gamemode before

hook.Add("PostGamemodeLoaded", "whoi.TutorialController", function()
    local fileName = "whoami.txt"
    if not file.Exists(fileName, "DATA") then
        file.Write(fileName, "Thank you for playing :)\nThis used to check if you have played gamemode to show tutorial")

        whoi.openTutorial()
    end
end)