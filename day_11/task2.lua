#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 11, task 2!")

local function load_file(filename)
    local octopus = {}
    setmetatable(octopus, {__index = function(table, key) return setmetatable({}, {__index = function(table, key) return {} end}) end})

    local f = io.open(filename)
    for line in f:lines()
    do
        table.insert(octopus, setmetatable({}, {__index = function(table, key) return {} end}))
        for level in line:gmatch("%d")
        do
            table.insert(octopus[#octopus], {level = tonumber(level), bonus = false})
        end
    end

    f:close()

    return octopus
end

local function clear_bonus(octopus)
    local clear_number = 0
    for i = 1, #octopus, 1
    do
        local level_line = octopus[i]
        for j = 1, #level_line, 1
        do
            if octopus[i][j].bonus == true
            then
                clear_number = clear_number + 1
                octopus[i][j].bonus = false
            end
        end
    end

    if clear_number == #octopus * #octopus[1]
    then
        return true
    else
        return false
    end
end

local function bonus_nine(octopus, i, j)
    if octopus[i-1][j-1].level then octopus[i-1][j-1].level = octopus[i-1][j-1].level + 1 end
    if octopus[i-1][j  ].level then octopus[i-1][j  ].level = octopus[i-1][j  ].level + 1 end
    if octopus[i-1][j+1].level then octopus[i-1][j+1].level = octopus[i-1][j+1].level + 1 end
    if octopus[i  ][j+1].level then octopus[i  ][j+1].level = octopus[i  ][j+1].level + 1 end
    if octopus[i+1][j+1].level then octopus[i+1][j+1].level = octopus[i+1][j+1].level + 1 end
    if octopus[i+1][j  ].level then octopus[i+1][j  ].level = octopus[i+1][j  ].level + 1 end
    if octopus[i+1][j-1].level then octopus[i+1][j-1].level = octopus[i+1][j-1].level + 1 end
    if octopus[i  ][j-1].level then octopus[i  ][j-1].level = octopus[i  ][j-1].level + 1 end
end

local function octopus_step(octopus)
    local flashes = 0

    -- Step 1: increases by 1:
    for i = 1, #octopus, 1
    do
        local level_line = octopus[i]
        for j = 1, #level_line, 1
        do
            octopus[i][j].level = octopus[i][j].level + 1
        end
    end

    -- Step 2: bonus greater than 9:
    local do_bonus = true
    while do_bonus do
        do_bonus = false

        for i = 1, #octopus, 1
        do
            local level_line = octopus[i]
            for j = 1, #level_line, 1
            do
                if octopus[i][j].level > 9 and octopus[i][j].bonus == false
                then
                    do_bonus = true
                    octopus[i][j].bonus = true
                    bonus_nine(octopus, i, j)
                end
            end
        end
    end

    -- Clear bonus:
    local is_clear_all = clear_bonus(octopus)

    -- Step 3: flash octopus:
    for i = 1, #octopus, 1
    do
        local level_line = octopus[i]
        for j = 1, #level_line, 1
        do
            if octopus[i][j].level > 9
            then
                flashes = flashes + 1
                octopus[i][j].level = 0
            end
        end
    end

    return flashes, is_clear_all
end

local function run_octopus(octopus)
    local i = 0
    local is_clear_all = false
    while not is_clear_all
    do
        i = i + 1
        _, is_clear_all = octopus_step(octopus)
    end

    return i
end

local octopus = load_file(arg[1])
local where_clear_all = run_octopus(octopus)
print(where_clear_all)
