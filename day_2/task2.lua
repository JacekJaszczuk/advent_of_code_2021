#!/usr/bin/env lua5.4
--local inspect = require("inspect")

print("Day 2, task 2!")

local function load_data(filename)
    -- Variable for return data:
    local ret = {}

    -- Read file:
    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    -- Parse data:
    for operation, value in data:gmatch("(%w+) (%d+)")
    do
        table.insert(ret, {operation=operation, value=value})
    end

    return ret
end

local function run_data(data)
    local horizontal = 0
    local depth = 0
    local aim = 0

    for _, v in ipairs(data)
    do
        if v.operation == "forward"
        then
            horizontal = horizontal + v.value
            depth = depth + aim * v.value
        elseif v.operation == "down"
        then
            aim = aim + v.value
        elseif v.operation == "up"
        then
            aim = aim - v.value
        end
    end

    return horizontal, depth
end


-- Main:
local data = load_data(arg[1])

--print(inspect(data))

local horizontal, depth = run_data(data)
print("Horizontal:", horizontal)
print("Depth:", depth)
print("Multiply:", horizontal*depth)