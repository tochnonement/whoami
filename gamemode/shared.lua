--[[

Author: tochonement
Email: tochonement@gmail.com

14.07.2021

--]]

GM.Name = "Who am I?"
GM.Author = "tochonement"
GM.Email = "tochonement@gmail.com"
GM.Version = "0.0.1"

-- ANCHOR Load sequence

whoi.load.auto("libraries/thirdparty/sh_pon.lua")
whoi.load.auto("libraries/thirdparty/cl_circle.lua")
whoi.load.auto("libraries/thirdparty/cl_blur.lua")

whoi.load.auto("libraries/sh_util.lua")
whoi.load.auto("libraries/cl_webicon.lua")
whoi.load.auto("libraries/cl_scale.lua")
whoi.load.auto("libraries/cl_font.lua")
whoi.load.auto("libraries/sh_netez.lua")
whoi.load.auto("libraries/sh_word.lua")
whoi.load.auto("libraries/sh_queue.lua")
whoi.load.auto("libraries/sv_round.lua")

whoi.load.auto("core/sv_core.lua")
whoi.load.auto("core/sv_hooks.lua")
whoi.load.auto("core/cl_hooks.lua")
whoi.load.auto("core/sv_net.lua")
whoi.load.auto("core/cl_net.lua")

whoi.word.load()

-- Load all vgui elements
do
    local path = GM.FolderName .. "/gamemode/core/derma/"
    local files = file.Find(path .. "*", "LUA")

    for _, v in ipairs(files) do
        whoi.load.client(path .. v)
    end
end