#!/usr/bin/env lua5.4

print("Day 1, task 2!")

-- Open and read input file:
local f = io.open(arg[1])
local data = {}
for value in f:lines("n")
do
    table.insert(data, value)
end
f:close()

-- Process input data:
local data_window = {}
for index, _ in ipairs(data)
do
    -- Exit when last window:
    if index > #data-2
    then
        break
    end

    -- Compute window:
    data_window[index] = data[index] + data[index+1] + data[index+2]
end

-- Check increased:
local old = data_window[1]
local increased = 0
for i = 2, #data_window, 1
do
    local new = data_window[i]

    if old < new
    then
        increased = increased + 1
    end

    old = new
end

print(#data)
print("Increased:", increased)