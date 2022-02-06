#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 13, task 1!")

local function load_file(filename)
    local dot_matrix = {}
    local dot_list = {}
    local fold_list = {}

    local dot_matrix_meta = {
        __index = function(table, key)
            table[key] = {}
            return table[key]
        end
    }
    setmetatable(dot_matrix, dot_matrix_meta)

    local f = io.open(filename)
    for line in f:lines()
    do
        local status, _, x, y = line:find("(%d+),(%d+)")
        if status
        then
            x = tonumber(x)
            y = tonumber(y)
            dot_matrix[x][y] = true
            table.insert(dot_list, {x = x, y = y})
        end

        local status, _, fold_type, fold_line = line:find("fold along (%w)=(%d+)")
        if status
        then
            fold_line = tonumber(fold_line)
            table.insert(fold_list, {fold_type = fold_type, fold_line = fold_line})
        end
    end
    f:close()

    return dot_matrix, dot_list, fold_list
end

local function do_fold(dot_matrix, dot_list, fold)
    local new_dot_list = {}

    for _, dot in ipairs(dot_list)
    do
        if fold.fold_type == "x" and dot.x > fold.fold_line
        then
            -- Remove dot from matrix:
            dot_matrix[dot.x][dot.y] = nil

            -- Calc delta:
            local delta = (dot.x - fold.fold_line) * 2
            dot.x = dot.x - delta

            -- Check dot is exist:
            if not dot_matrix[dot.x][dot.y]
            then
                -- Add dot to matrix, and list:
                dot_matrix[dot.x][dot.y] = true
                table.insert(new_dot_list, dot)
            end
        elseif fold.fold_type == "y" and dot.y > fold.fold_line
        then
            -- Remove dot from matrix:
            dot_matrix[dot.x][dot.y] = nil

            -- Calc delta:
            local delta = (dot.y - fold.fold_line) * 2
            dot.y = dot.y - delta

            -- Check dot is exist:
            if not dot_matrix[dot.x][dot.y]
            then
                -- Add dot to matrix, and list:
                dot_matrix[dot.x][dot.y] = true
                table.insert(new_dot_list, dot)
            end
        else
            -- Dot is good and not fold, add it:
            table.insert(new_dot_list, dot)
        end
    end

    dot_list = new_dot_list

    return #dot_list
end

local dot_matrix, dot_list, fold_list = load_file(arg[1])
--print(inspect(dot_matrix))
--print(inspect(dot_list))
--print(inspect(fold_list))

print(do_fold(dot_matrix, dot_list, fold_list[1]))