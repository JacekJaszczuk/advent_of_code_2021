#!/usr/bin/env lua5.4

print("Day 7, task 1!")

local function load_file(filename)
    local ret = {}
    
    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    for position in data:gmatch("(%d+),")
    do
        position = tonumber(position)
        table.insert(ret, position)
    end

    return ret
end

local positions = load_file(arg[1])

local max_position = arg[2]
local min_fuel = math.maxinteger
for now_position = 0, max_position, 1
do
    local fuel_sum = 0
    for _, position in ipairs(positions)
    do
        fuel_sum = fuel_sum + (math.abs(now_position - position))
    end

    if fuel_sum < min_fuel
    then
        min_fuel = fuel_sum
    end
end

print(min_fuel)