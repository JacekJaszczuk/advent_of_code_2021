#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 6, task 1!")
print("Lanternfish!")

local Lanternfish
Lanternfish = {
    new = function(timer)
        local ret = {
            timer = timer,
        }
        setmetatable(ret, Lanternfish)

        return ret
    end,

    iteration = function(self)
        self.timer = self.timer - 1
        if self.timer == -1
        then
            self.timer = 6
            return Lanternfish.new(8)
        else
            return nil
        end
    end,
}
Lanternfish.__index = Lanternfish

local function load_file(filename)
    local ret = {}

    local f = io.open(filename)
    local data = f:read("a")
    f:close()
    data = data .. ","

    for timer in data:gmatch("(%d),")
    do
        table.insert(ret, Lanternfish.new(timer))
    end

    return ret
end

local lanternfishes = load_file(arg[1])

local max_day = tonumber(arg[2])
for now_day = 1, max_day, 1
do
    local buf = {}

    -- Do one day:
    for _, lanternfish in ipairs(lanternfishes)
    do
        table.insert(buf, lanternfish:iteration())
    end

    -- Add new lanternfish:
    for _, lanternfish in ipairs(buf)
    do
        table.insert(lanternfishes, lanternfish)
    end
end

print("Lanternfishes:", #lanternfishes)