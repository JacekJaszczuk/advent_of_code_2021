#!/usr/bin/env lua5.4

print("Day 7, task 2!")

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

local function find_fuel_cost(position_different)
    ret = 0
    local val = 1
    for i = 1, position_different, 1
    do
        ret = ret + val
        val = val + 1
    end

    return ret
end

local max_position = arg[2]

-- Generate fuel cost list:
local fuel_cost_list = {}
for i = 1, max_position, 1
do
    fuel_cost_list[i] = find_fuel_cost(i)
end
fuel_cost_list[0] = 0

local positions = load_file(arg[1])

local min_fuel = math.maxinteger
for now_position = 0, max_position, 1
do
    local fuel_sum = 0
    for _, position in ipairs(positions)
    do
        fuel_sum = fuel_sum + fuel_cost_list[math.abs(now_position - position)]
    end

    if fuel_sum < min_fuel
    then
        min_fuel = fuel_sum
    end
end

print(min_fuel)