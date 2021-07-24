--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.util = whoi.util or {}

local lib = whoi.util

do
    local function setter(tbl, key, name)
        tbl["Set" .. name] = function(self, value)
            self[key] = value

            return self
        end
    end

    local function getter(tbl, key, name, force)
        local func = function(self) return self[key] end

        tbl["Get" .. name] = func

        if force and force == FORCE_BOOL then
            tbl["Is" .. name] = func
        end
    end

    function lib.accessor(tbl, key, name, force)
        name = name or string.upper(string.Left(key, 1)) .. string.sub(key, 2)

        setter(tbl, key, name)
        getter(tbl, key, name, force)
    end
end

do
    local prefixText = "(WHOI) "
    local prefixColor = Color(251, 197, 49)

    function lib.print(...)
        MsgC(prefixColor, prefixText, color_white, ...)
        Msg("\n")
    end
end

if CLIENT then
    do
        local function process(panel, class, callback)
            for _, child in ipairs(panel:GetChildren()) do
                if child.ClassName == class then
                    if IsValid(child) then
                        callback(child)
                    end
                    return
                else
                    process(child, class, callback)
                end
            end
        end

        function lib.findPanel(class, callback)
            process(vgui.GetWorldPanel(), class, callback)
        end
    end
end