#!/usr/bin/env lua5.4
--local inspect = require("inspect")

print("Day 3, task 1!")

local function load_data(filename)
    local zeros = {}
    local ones = {}
    local gamma = ""
    local epsilon = ""

    -- Read file:
    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    -- Count zeros and ones:
    for word in data:gmatch("(%w+)")
    do
        local i = 0
        for digit in word:gmatch("(%d)")
        do
            i = i + 1

            digit = tonumber(digit)
            if digit == 0
            then
                if not zeros[i] then zeros[i] = 0 end
                zeros[i] = zeros[i] + 1
            elseif digit == 1
            then
                if not ones[i] then ones[i] = 0 end
                ones[i] = ones[i] + 1
            end
        end
    end

    for i = 1, #zeros, 1
    do
        if zeros[i] > ones[i]
        then
            gamma = gamma.."0"
            epsilon = epsilon.."1"
        elseif ones[i] > zeros[i] then
            gamma = gamma.."1"
            epsilon = epsilon.."0"
        end
    end

    return tonumber(gamma, 2), tonumber(epsilon, 2)
end

local gamma, epsilon = load_data(arg[1])
print(gamma, epsilon, gamma * epsilon)