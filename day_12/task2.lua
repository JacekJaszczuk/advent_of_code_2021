#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 12, task 1!")

local function load_file(filename)
    local graph = {}
    local graph_meta = {
        __index = function (table, key)
            table[key] = {connected = {}, name = key}
            return table[key]
        end
    }
    setmetatable(graph, graph_meta)

    local f = io.open(filename)
    for line in f:lines()
    do
        local _, _, vertice1, vertice2 = line:find("(%w+)-(%w+)")
        table.insert(graph[vertice1].connected, graph[vertice2])
        table.insert(graph[vertice2].connected, graph[vertice1])
    end
    f:close()

    return graph
end

local function add_path(paths, path, connect_vertice, set_twice)
    if not set_twice
    then
        set_twice = path.twice_visit
    end

    -- Clone current path and add last vertice:
    local new_path = {befores_in = {}}
    for _, vertice in ipairs(path)
    do
        table.insert(new_path, vertice)
    end

    -- Clone befores:
    for _, before_in in ipairs(path.befores_in)
    do
        table.insert(new_path.befores_in, before_in)
        new_path[before_in] = true
    end
    table.insert(new_path, connect_vertice)

    -- Clone twice visit:
    new_path.twice_visit = set_twice

    -- If small character vertice name, we add it:
    if connect_vertice.name ~= connect_vertice.name:upper()
    then
        table.insert(new_path.befores_in, connect_vertice.name)
        new_path[connect_vertice.name] = true
    end
    table.insert(paths, new_path)
end

local function print_path(path)
    for _, v in ipairs(path)
    do
        io.stdout:write(v.name .. "-")
    end
    io.stdout:write("\n")
end

local function print_all_paths(paths)
    for i, v in ipairs(paths)
    do
        io.stdout:write(tostring(i) .. ": ")
        print_path(v)
    end
end

local function find_path(graph)
    local paths = {{graph.start, befores_in = {"start"}, start = true, twice_visit = false}}
    local paths_with_end = {}

    --for x = 1, 100, 1 do
    while #paths ~= 0 do
        local path = table.remove(paths)
        -- If last vertice name is end, we add path to path_with_end list:
        if path[#path].name == "end"
        then
            table.insert(paths_with_end, path)
        else
            for _, connect_vertice in ipairs(path[#path].connected)
            do
                -- If not connect_vertice before we add new path:
                if not path[connect_vertice.name]
                then
                    add_path(paths, path, connect_vertice)
                else
                    if connect_vertice.name ~= "start" and path.twice_visit == false
                    then
                        -- We can add this small cave twice:
                        --path.twice_visit = true
                        add_path(paths, path, connect_vertice, true)
                    end
                end
            end
        end
    end

    --print_all_paths(paths_with_end)

    return #paths_with_end
end

local graph = load_file(arg[1])
print(find_path(graph))