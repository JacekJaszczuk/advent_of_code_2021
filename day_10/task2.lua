#!/usr/bin/env lua5.4

local inspect = require "inspect"

print("Day 10, task 2!")

local open_chunks  = {
    ["("] = {normal = "(", reverse = ")", value = 1},
    ["["] = {normal = "[", reverse = "]", value = 2},
    ["{"] = {normal = "{", reverse = "}", value = 3},
    ["<"] = {normal = "<", reverse = ">", value = 4},
}
local close_chunks = {
    [")"] = {normal = ")", reverse = "(", value = 1},
    ["]"] = {normal = "]", reverse = "[", value = 2},
    ["}"] = {normal = "}", reverse = "{", value = 3},
    [">"] = {normal = ">", reverse = "<", value = 4},
}

local function load_file(filename)
    local chunks_lines = {}

    local f = io.open(filename)
    for line in f:lines()
    do
        table.insert(chunks_lines, line)
    end
    f:close()

    return chunks_lines
end

local function find_incomplete(chunks_line)
    local stack = {}
    local sum = 0

    for chunk in chunks_line:gmatch("%g")
    do
        if open_chunks[chunk]
        then
            table.insert(stack, open_chunks[chunk])
        elseif close_chunks[chunk]
        then
            local chunk_from_stack = table.remove(stack)
            if chunk ~= chunk_from_stack.reverse
            then
                return nil
            end
        end
    end

    for chunk in function() return table.remove(stack) end
    do
        sum = sum * 5 + chunk.value
    end

    return sum
end

local function find_all_incomplete(chunks_lines)
    local sums = {}
    for _, chunks_line in ipairs(chunks_lines)
    do
        local sum = find_incomplete(chunks_line)
        if sum
        then
            table.insert(sums, sum)
        end
    end

    table.sort(sums)

    return sums[math.ceil(#sums/2)]
end

local chunks_lines = load_file(arg[1])

print(find_all_incomplete(chunks_lines))