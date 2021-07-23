--[[

Author: tochonement
Email: tochonement@gmail.com

23.07.2021

--]]

whoi.queue = whoi.queue or {}

local queue = whoi.queue

-- ANCHOR Meta

local QUEUE = {}
QUEUE.__index = QUEUE

function QUEUE:Push(any)
    local index = self.count + 1

    self.items[index] = any

    self.count = index
end

function QUEUE:Pop()
    return self:Remove(1)
end

function QUEUE:Remove(index)
    local item = self.items[index]

    if item then
        self.count = self.count - 1

        return table.remove(self.items, index)
    end
end

function QUEUE:Count()
    return self.count
end

function QUEUE:Items()
    return self.items
end

-- ANCHOR Functions

function queue.create()
    local object = setmetatable({}, QUEUE)

    object.items = {}
    object.count = 0

    return object
end