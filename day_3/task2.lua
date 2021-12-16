#!/usr/bin/env lua5.4
--local inspect = require("inspect")

print("Day 3, task 2!")

local function load_data(filename)
    local ret = {}

    local f = io.open(filename)
    for number in f:lines()
    do
        table.insert(ret, number)
    end
    f:close()

    return ret
end

local function get_rating_iteration(list, position, is_oxygen)
    local ret = {}

    -- How many zeros and ones on position:
    local zeros = 0
    local ones = 0
    for _, binary_number in ipairs(list)
    do
        if binary_number:sub(position, position) == "0"
        then
            zeros = zeros + 1
        elseif binary_number:sub(position, position) == "1"
        then
            ones = ones + 1
        end
    end

    -- Add good number:
    for _, binary_number in ipairs(list)
    do
        if is_oxygen
        then
            if (zeros > ones) and binary_number:sub(position, position) == "0"
            then
                table.insert(ret, binary_number)
            elseif (ones >= zeros) and binary_number:sub(position, position) == "1"
            then
                table.insert(ret, binary_number)
            end
        else
            if (ones >= zeros) and binary_number:sub(position, position) == "0"
            then
                table.insert(ret, binary_number)
            elseif (zeros > ones) and binary_number:sub(position, position) == "1"
            then
                table.insert(ret, binary_number)
            end
        end
    end

    return ret
end

local function get_rating(list, is_oxygen)
    local i = 1
    while #list ~= 1
    do
        list = get_rating_iteration(list, i, is_oxygen)
        i = i + 1
    end

    return tonumber(list[1], 2)
end

local binary_numbers = load_data(arg[1])
local oxygen = get_rating(binary_numbers, true)
local co2 = get_rating(binary_numbers, false)
print("Oxygen:", oxygen)
print("CO2:", co2)
print("Multiply:", oxygen*co2)