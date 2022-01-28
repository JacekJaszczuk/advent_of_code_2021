#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 9, task 1!")

local function load_file(filename)
    local metatable_heightmap = {
        __index = function(table, key)
            return setmetatable({}, {__index = function(table, key) return 10 end})
        end
    }

    local metatable_line_buf = {
        __index = function(table, key)
            return 10
        end
    }

    local f = io.open(filename)

    local heightmap = {}
    setmetatable(heightmap, metatable_heightmap)

    for line in f:lines()
    do
        --print(line)
        local line_buf = {}
        setmetatable(line_buf, metatable_line_buf)
        for number in line:gmatch("%d")
        do
            --print(number)
            table.insert(line_buf, tonumber(number))
        end
        table.insert(heightmap, line_buf)
    end

    f:close()

    return heightmap
end

local function find_lowest(heightmap)
    local lowest = {}

    for i = 1, #heightmap, 1
    do
        for j = 1, #heightmap[i], 1
        do
            --print(heightmap[i][j])
            local this  = heightmap[i][j]

            local left  = heightmap[i][j-1]
            local right = heightmap[i][j+1]
            local up    = heightmap[i-1][j]
            local down  = heightmap[i+1][j]

            if this < left and
               this < right and
               this < up and
               this < down
            then
                table.insert(lowest, this)
            end
        end
    end

    return lowest
end

local function calc_answer(lowest)
    local answer = 0
    for _, v in ipairs(lowest)
    do
        answer = answer + 1 + v
    end

    return answer
end

local heightmap = load_file(arg[1])
--print(inspect(heightmap))

local lowest = find_lowest(heightmap)
--print(inspect(lowest))

print(calc_answer(lowest))