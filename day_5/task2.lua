#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 5, task 2!")

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
        else -- Diagonal:
            -- Check who is lower or bigger:
            --print("Punkt:", point_pair.start_x, point_pair.start_y, point_pair.stop_x, point_pair.stop_y)
            local low_x, low_y, big_x, big_y
            local modify_x, modify_y
            if point_pair.start_x > point_pair.stop_x
            then
                modify_x = -1
                big_x = point_pair.start_x
                low_x = point_pair.stop_x
            else
                modify_x = 1
                low_x = point_pair.start_x
                big_x = point_pair.stop_x
            end

            if point_pair.start_y > point_pair.stop_y
            then
                modify_y = -1
                big_y = point_pair.start_y
                low_y = point_pair.stop_y
            else
                modify_y = 1
                low_y = point_pair.start_y
                big_y = point_pair.stop_y
            end

            for j = 0, big_x-low_x, 1
            do
                --print("Start:", point_pair.start_y)
                --print(point_pair.start_y+j*modify_y)
                board[point_pair.start_x+j*modify_x+((point_pair.start_y+j*modify_y)<<16)] = board[point_pair.start_x+j*modify_x+((point_pair.start_y+j*modify_y)<<16)] + 1
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