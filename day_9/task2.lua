#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 9, task 2!")

local function load_file(filename)
    local metatable_heightmap = {
        __index = function(table, key)
            return setmetatable({}, {__index = function(table, key) return {v = 10} end})
        end
    }

    local metatable_line_buf = {
        __index = function(table, key)
            return {v = 10}
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
            table.insert(line_buf, {i = #heightmap + 1, j = #line_buf + 1, v = tonumber(number)})
        end
        table.insert(heightmap, line_buf)
    end

    f:close()

    return heightmap
end

local function find_lowest(heightmap)
    local lowest = {}
    local coordinates = {}

    for i = 1, #heightmap, 1
    do
        for j = 1, #heightmap[i], 1
        do
            --print(heightmap[i][j])
            local this              = heightmap[i][j].v
            local this_coordinates  = heightmap[i][j]

            local left  = heightmap[i][j-1].v
            local right = heightmap[i][j+1].v
            local up    = heightmap[i-1][j].v
            local down  = heightmap[i+1][j].v

            if this < left and
               this < right and
               this < up and
               this < down
            then
                table.insert(lowest, this)
                table.insert(coordinates, this_coordinates)
            end
        end
    end

    return lowest, coordinates
end

local function calc_answer(lowest)
    local answer = 0
    for _, v in ipairs(lowest)
    do
        answer = answer + 1 + v
    end

    return answer
end

local function find_basin(heightmap, coordinate)
    local to_visit = {coordinate}
    local ever_exist_in_to_visit = {[coordinate] = true}
    local visited = {}

    while true do
        local current  = table.remove(to_visit)
        if not current
        then
            break
        end

        local i = current.i
        local j = current.j

        local this  = heightmap[i][j]
        local left  = heightmap[i][j-1]
        local right = heightmap[i][j+1]
        local up    = heightmap[i-1][j]
        local down  = heightmap[i+1][j]

        if left.v < 9 and left.v > this.v and not ever_exist_in_to_visit[left]
        then
            table.insert(to_visit, left)
            ever_exist_in_to_visit[left] = true
            --print("Add left!")
        end

        if right.v < 9 and right.v > this.v and not ever_exist_in_to_visit[right]
        then
            table.insert(to_visit, right)
            ever_exist_in_to_visit[right] = true
            --print("Add right!")
        end

        if up.v < 9 and up.v > this.v and not ever_exist_in_to_visit[up]
        then
            table.insert(to_visit, up)
            ever_exist_in_to_visit[up] = true
            --print("Add up!")
        end

        if down.v < 9 and down.v > this.v and not ever_exist_in_to_visit[down]
        then
            table.insert(to_visit, down)
            ever_exist_in_to_visit[down] = true
            --print("Add down!")
        end

        table.insert(visited, current)
    end

    return #visited
end

local function find_all_basins(heightmap, coordinates)
    local basins = {}

    for _, coordinate in ipairs(coordinates)
    do
        table.insert(basins, find_basin(heightmap, coordinate))
    end

    return basins
end

local function find_answer_task2(basins)
    table.sort(basins)

    return basins[#basins] * basins[#basins-1] * basins[#basins-2]
end

local heightmap = load_file(arg[1])
--print(inspect(heightmap))

local lowest, coordinates = find_lowest(heightmap)
--print(inspect(lowest))
--print(inspect(coordinates))

--print(calc_answer(lowest))
local basins = find_all_basins(heightmap, coordinates)
--print(inspect(basins))

print(find_answer_task2(basins))