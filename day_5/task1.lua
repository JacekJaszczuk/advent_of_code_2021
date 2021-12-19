#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 5, task 1!")

local function load_file(filename)
    local points = {}

    local f = io.open(filename)

    for line in f:lines()
    do
        local buf = {}
        _, _, buf.start_x, buf.start_y, buf.stop_x, buf.stop_y = line:find("(%d+),(%d+) %-> (%d+),(%d+)")
        buf.start_x = tonumber(buf.start_x)
        buf.start_y = tonumber(buf.start_y)
        buf.stop_x = tonumber(buf.stop_x)
        buf.stop_y = tonumber(buf.stop_y)

        table.insert(points, buf)
    end

    --print(inspect(points))

    f:close()

    return points
end

-- Not work:
local function draw_lines(points)
    -- Define board:
    local board = {}
    function board.__index(tab, key)
        tab[key] = {
            __index = function(tab, key)
                tab[key] = 0
                return tab[key]
            end
        }
        setmetatable(tab[key], tab[key])
        --print(inspect(tab[key]))
        return tab[key]
    end
    setmetatable(board, board)

    -- Process points:
    for i, point_pair in ipairs(points)
    do
        if point_pair.start_x == point_pair.stop_x
        then
            for j = point_pair.start_y, point_pair.stop_y, 1
            do
                board[point_pair.start_x][j] = board[point_pair.start_x][j] + 1
            end

            for j = point_pair.stop_y, point_pair.start_y, 1
            do
                board[point_pair.start_x][j] = board[point_pair.start_x][j] + 1
            end
        elseif point_pair.start_y == point_pair.stop_y
        then
            for j = point_pair.start_x, point_pair.stop_x, 1
            do
                board[j][point_pair.start_y] = board[j][point_pair.start_y] + 1
            end

            for j = point_pair.stop_x, point_pair.start_x, 1
            do
                board[j][point_pair.start_y] = board[j][point_pair.start_y] + 1
            end
        end
    end

    -- Find all two and more:
    local more_than_two = 0
    for _, row in pairs(board)
    do
        if type(row) == "table"
        then
            for _, value in pairs(row)
            do
                --print(value)
                if type(value) == "number" and value >= 2
                then
                    more_than_two = more_than_two + 1
                end
            end
        end
    end

    print(inspect(board))

    print("Answer:", more_than_two)
end

local function draw_lines2(points)
    -- Define board:
    local board = {
        __index = function(tab, key)
            tab[key] = 0
            return tab[key]
        end
    }
    setmetatable(board, board)

    -- Process points:
    for _, point_pair in ipairs(points)
    do
        if point_pair.start_x == point_pair.stop_x
        then
            for j = point_pair.start_y, point_pair.stop_y, 1
            do
                board[point_pair.start_x+(j<<16)] = board[point_pair.start_x+(j<<16)] + 1
            end

            for j = point_pair.stop_y, point_pair.start_y, 1
            do
                board[point_pair.start_x+(j<<16)] = board[point_pair.start_x+(j<<16)] + 1
            end
        elseif point_pair.start_y == point_pair.stop_y
        then
            for j = point_pair.start_x, point_pair.stop_x, 1
            do
                board[j+(point_pair.start_y<<16)] = board[j+(point_pair.start_y<<16)] + 1
            end

            for j = point_pair.stop_x, point_pair.start_x, 1
            do
                board[j+(point_pair.start_y<<16)] = board[j+(point_pair.start_y<<16)] + 1
            end
        end
    end

    -- Find all two and more:
    local more_than_two = 0
    for _, number in pairs(board)
    do
        if type(number) =="number" and number >= 2
        then
            more_than_two = more_than_two + 1
        end
    end

    --print(inspect(board))

    print("Answer:", more_than_two)
end

local points = load_file(arg[1])

draw_lines2(points)