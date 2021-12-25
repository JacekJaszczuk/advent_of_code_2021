#!/usr/bin/env lua5.4

local inspect = require("inspect")
local Set = require("Set")

print("Day 8, task 2!")

local function load_file(filename)
    local f = io.open(filename)
    local sum = 0
    for line in f:lines()
    do
        local ten_numbers = {}
        local four_numbers = {}

        for word in line:gmatch("(%w+)", init)
        do
            local set = Set:new()
            for char in word:gmatch("(%w)")
            do
                set:add(char)
            end

            table.insert(ten_numbers, {string = word, set = set})
        end

        for i = 1, 4, 1
        do
            four_numbers[i] = ten_numbers[10+i]
            ten_numbers[10+i] = nil
        end

        -- Find 1, 4, 7, 8:
        local digits = {}
        for _, number in ipairs(ten_numbers)
        do
            if #number.string == 2
            then
                digits[1] = number
            elseif #number.string == 3
            then
                digits[7] = number
            elseif #number.string == 4
            then
                digits[4] = number
            elseif #number.string == 7
            then
                digits[8] = number
            end
        end

        -- Find another number:
        for _, number in ipairs(ten_numbers)
        do
            if #number.string == 5
            then
                -- Check 3:
                if (number.set - digits[1].set):len() == 3
                then
                    digits[3] = number
                -- Check 5:
                elseif (number.set - digits[4].set):len() == 2
                then
                    digits[5] = number
                -- Check 2: 
                else
                    digits[2] = number
                end

            elseif #number.string == 6
            then
                -- Check 6:
                if (number.set + digits[1].set):len() == 7
                then
                    digits[6] = number
                -- Check 0:
                elseif (number.set - digits[4].set):len() == 3
                then
                    digits[0] = number
                -- Check 9: 
                else
                    digits[9] = number
                end
            end
        end

        -- Search number:
        local str_number = ""
        for _, number in ipairs(four_numbers)
        do
            for i = 0, 9, 1
            do
                if (number.set - digits[i].set):len() == 0 and (digits[i].set - number.set):len() == 0
                then
                    str_number = str_number .. tostring(i)
                end
            end
        end

        sum = sum + tonumber(str_number)

    end
    f:close()

    return sum
end

print(load_file(arg[1]))