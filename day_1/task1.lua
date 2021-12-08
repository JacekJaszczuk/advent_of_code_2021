#!/usr/bin/env lua5.4

print("Hello!")

local stats = {
    all = 1,
    decreased = 0,
    increased = 0,
}

local f = io.open(arg[1])
local old = f:read("n")
for new in f:lines("n")
do
    stats.all = stats.all + 1

    if old < new
    then
        stats.increased = stats.increased + 1
    elseif old > new
    then
        stats.decreased = stats.decreased + 1
    end

    old = new
end
f:close()

print("All", stats.all)
print("Inc", stats.increased)
print("Dec", stats.decreased)