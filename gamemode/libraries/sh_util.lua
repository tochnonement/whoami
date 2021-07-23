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