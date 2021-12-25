#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 6, task 2!")
print("Lanternfish!")

local function load_file(filename)
    local ret = {}

    -- Initialize ret:
    for i = 0, 8, 1
    do
        ret[i] = 0
    end

    local f = io.open(filename)
    local data = f:read("a")
    f:close()
    data = data .. ","

    for timer in data:gmatch("(%d),")
    do
        timer = tonumber(timer)
        ret[timer] = ret[timer] + 1
    end

    return ret
end

local lanternfishes = load_file(arg[1])

local max_day = tonumber(arg[2])
for now_day = 1, max_day, 1
do
    -- Do one day:
    local zeros = lanternfishes[0]
    for i = 0, 7, 1
    do
        lanternfishes[i] = lanternfishes[i+1]
    end
    lanternfishes[8] = zeros
    lanternfishes[6] = lanternfishes[6] + zeros
end

local sum_of_lanternfishes = 0
for i = 0, 8, 1
do
    sum_of_lanternfishes = sum_of_lanternfishes + lanternfishes[i]
end

print(sum_of_lanternfishes)