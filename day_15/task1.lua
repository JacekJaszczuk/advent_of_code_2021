#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 15, task 1!")

local function load_file(filename)
    local f = io.open(filename)

    local matrix = {}
    local matrix_meta = {
        __index = function ()
            return {}
        end
    }
    setmetatable(matrix, matrix_meta)

    local i = 1
    for line in f:lines()
    do
        matrix[i] = {}
        local j = 1
        for char in line:gmatch("%d")
        do
            matrix[i][j] = {
                i = i,
                j = j,
                value = tonumber(char),
                path = nil,
            }

            j = j + 1
        end

        i = i + 1
    end

    f:close()

    return matrix
end

local function calc_one_path(point_now, point, points)
    if point_now and not point_now.path
    then
        point_now.path = point.path + point_now.value
        table.insert(points, point_now)
    end
end

local clock_sort = 0

local function calc_path(matrix)
    -- Add first point:
    local first_point = matrix[1][1]
    first_point.path = 0
    local points = {first_point}

    while #points ~= 0
    do
        -- Get last element from list:
        local point = table.remove(points)

        local i = point.i
        local j = point.j

        -- Check up:
        local point_now = matrix[i-1][j]
        calc_one_path(point_now, point, points)

        -- Check right:
        local point_now = matrix[i][j+1]
        calc_one_path(point_now, point, points)

        -- Check down:
        local point_now = matrix[i+1][j]
        calc_one_path(point_now, point, points)

        -- Check left:
        local point_now = matrix[i][j-1]
        calc_one_path(point_now, point, points)

        -- Sort points
        local clock_start = os.clock()
        table.sort(points, function(a, b)
            return a.path > b.path
        end)
        local clock_stop = os.clock()
        clock_sort = clock_sort + (clock_stop - clock_start)
    end
end

local matrix = load_file(arg[1])

calc_path(matrix)

--print(inspect(matrix))
local y = #matrix
local x = #matrix[1]
print("Clock:", clock_sort)
local end_clock = os.clock()
print("Clock all:", end_clock)
print("Sort percentage time:", clock_sort / end_clock * 100)
print("Path:", matrix[y][x].path)