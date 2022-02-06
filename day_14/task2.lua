#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 14, task 2!")

local polymer_template_meta = {
    __index = function(tab, key)
        tab[key] = {count = 0, key = key}
        table.insert(tab, tab[key])
        return tab[key]
    end
}

local function load_file(filename)
    local polymer_template = {}
    setmetatable(polymer_template, polymer_template_meta)
    local rules = {}

    local f = io.open(filename)
    local polymer_template_buf = f:read("l")
    for i = 1, #polymer_template_buf-1, 1
    do
        local char1 = polymer_template_buf:sub(i, i)
        local char2 = polymer_template_buf:sub(i+1, i+1)
        local rule = char1 .. char2

        polymer_template[rule].count = polymer_template[rule].count + 1
    end
    f:read("l") -- Read empty line.
    for line in f:lines()
    do
        local _, _, rule, value = line:find("(%w+)%s+->%s+(%w+)")
        --table.insert(rules, {rule = rule, value = value})
        rules[rule] = value
    end
    f:close()

    return polymer_template, rules
end

local function do_step(polymer_template, rules)
    local new_polymer_template = {}
    setmetatable(new_polymer_template, polymer_template_meta)

    for i = 1, #polymer_template, 1
    do
        -- Pair polymer produce two new pair polymer:
        local pair_polymer = polymer_template[i]

        local polymer1 = pair_polymer.key:sub(1, 1)
        local polymer2 = pair_polymer.key:sub(2, 2)
        local produced_polymer = rules[pair_polymer.key]

        local new_polymer1 = polymer1 .. produced_polymer
        local new_polymer2 = produced_polymer .. polymer2

        new_polymer_template[new_polymer1].count = new_polymer_template[new_polymer1].count + pair_polymer.count
        new_polymer_template[new_polymer2].count = new_polymer_template[new_polymer2].count + pair_polymer.count
    end

    return new_polymer_template
end

local function do_steps(polymer_template, rules, times)
    local counts = {}
    local len = 0
    setmetatable(counts, polymer_template_meta)

    for i = 1, times, 1
    do
        polymer_template = do_step(polymer_template, rules)
    end

    -- Count element:
    for i = 1, #polymer_template, 1
    do
        local pair_polymer = polymer_template[i]

        local polymer1 = pair_polymer.key:sub(1, 1)
        local polymer2 = pair_polymer.key:sub(2, 2)

        counts[polymer1].count = counts[polymer1].count + pair_polymer.count
        counts[polymer2].count = counts[polymer2].count + pair_polymer.count

        len = len + pair_polymer.count
    end

    --print(len+1)
    -- Fix counts:
    for i = 1, #counts, 1
    do
        local count = counts[i]
        count.count = math.ceil(count.count/2)
    end

    -- Sort counts:
    table.sort(counts, function(element1, element2)
        return element1.count < element2.count
    end)

    --print(inspect(counts))
    return counts[#counts].count - counts[1].count
end

local polymer_template, rules = load_file(arg[1])
--print(inspect(polymer_template))
--print(inspect(rules))

print(do_steps(polymer_template, rules, tonumber(arg[2])))