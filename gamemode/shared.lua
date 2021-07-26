--[[

Author: tochonement
Email: tochonement@gmail.com

14.07.2021

--]]

GM.Name = "Who am I?"
GM.Author = "tochonement"
GM.Email = "tochonement@gmail.com"
GM.Version = "1.0.0"

if game.SinglePlayer() then
    error("You can't play this gamemode in singleplayer!")
    return
end

-- ANCHOR Enums

whoi.state = {}
whoi.state.IDLE = 0
whoi.state.PREPARING = 1
whoi.state.STARTED = 2

-- ANCHOR Team

TEAM_PLAYER = 1

team.SetUp(TEAM_PLAYER, "Player", color_white)

-- ANCHOR Load sequence

whoi.load.client("config/colors.lua")
whoi.load.shared("config/shared.lua")

whoi.load.auto("libraries/thirdparty/sh_pon.lua")
whoi.load.auto("libraries/thirdparty/cl_circle.lua")
whoi.load.auto("libraries/thirdparty/cl_blur.lua")
whoi.load.auto("libraries/thirdparty/cl_bind.lua")

whoi.load.auto("libraries/sh_util.lua")
whoi.load.auto("libraries/cl_webicon.lua")
whoi.load.auto("libraries/cl_scale.lua")
whoi.load.auto("libraries/cl_font.lua")
whoi.load.auto("libraries/sh_netez.lua")
whoi.load.auto("libraries/cl_netvar.lua")
whoi.load.auto("libraries/sv_netvar.lua")
whoi.load.auto("libraries/sh_word.lua")
whoi.load.auto("libraries/sh_queue.lua")
whoi.load.auto("libraries/sh_round.lua")
whoi.load.auto("libraries/sv_round.lua")
whoi.load.auto("libraries/sh_lang.lua")

whoi.load.auto("core/sv_core.lua")
whoi.load.auto("core/cl_core.lua")
whoi.load.auto("core/sv_hooks.lua")
whoi.load.auto("core/cl_hooks.lua")
whoi.load.auto("core/sv_net.lua")
whoi.load.auto("core/cl_net.lua")
whoi.load.auto("core/sv_resource.lua")
whoi.load.auto("core/sh_sam_support.lua")

whoi.word.load()
whoi.lang.init()

-- Load all vgui elements
do
    local path = GM.FolderName .. "/gamemode/core/derma/"
    local files = file.Find(path .. "*", "LUA")

    for _, v in ipairs(files) do
        whoi.load.client(path .. v)
    end
end