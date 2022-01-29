#!/usr/bin/env lua5.4

--local inspect = require "inspect"

print("Day 10, task 1!")

local open_chunks  = {
    ["("] = {normal = "(", reverse = ")", value = 3},
    ["["] = {normal = "[", reverse = "]", value = 57},
    ["{"] = {normal = "{", reverse = "}", value = 1197},
    ["<"] = {normal = "<", reverse = ">", value = 25137},
}
local close_chunks = {
    [")"] = {normal = ")", reverse = "(", value = 3},
    ["]"] = {normal = "]", reverse = "[", value = 57},
    ["}"] = {normal = "}", reverse = "{", value = 1197},
    [">"] = {normal = ">", reverse = "<", value = 25137},
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
                return chunk
            end
        end
    end

    return nil
end

local function find_all_incomplete(chunks_lines)
    local sum = 0
    for _, chunks_line in ipairs(chunks_lines)
    do
        local chunk = find_incomplete(chunks_line)
        if chunk
        then
            sum = sum + close_chunks[chunk].value
        end
    end

    return sum
end

local chunks_lines = load_file(arg[1])

print(find_all_incomplete(chunks_lines))