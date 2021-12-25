#!/usr/bin/env lua5.4

print("Day 8, task 1!")

local function load_file(filename)
    local sum = 0
    local f = io.open(filename)
    for line in f:lines()
    do
        local init = line:find("|")
        for word in line:gmatch("(%w+)", init)
        do
            if #word == 2 or #word == 3 or #word == 4 or #word == 7
            then
                sum = sum + 1
            end
        end
    end
    f:close()

    return sum
end

print(load_file(arg[1]))