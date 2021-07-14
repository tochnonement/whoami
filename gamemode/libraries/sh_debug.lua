--[[

Author: tochonement
Email: tochonement@gmail.com

29.03.2021

--]]

whoi.debug = whoi.debug or {}

local dbg = whoi.debug

local color_prefix = Color(9, 143, 252)
local color_error = Color(255, 0, 0)
local color_success = Color(55, 252, 104)

function dbg.print(...)
    MsgC(color_prefix, "[Who am I] ", color_white, ...)
    Msg("\n")
end

function dbg.error(text, solution)
    dbg.print(color_error, "Error occured: ", text)

    if solution then
        MsgC(color_error, "  Probable solution way: ", color_white, solution, "\n")
    end
end