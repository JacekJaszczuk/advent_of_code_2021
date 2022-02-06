#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 14, task 1!")

--for i = string.byte("a"), string.byte("z"), 1
--do
--    print(string.char(i))
--end
--os.exit(11)

local function load_file(filename)
    local polymer_template
    local rules = {}

    local f = io.open(filename)
    polymer_template = f:read("l")
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

    for i = 1, #polymer_template-1, 1
    do
        local char1 = polymer_template:sub(i, i)
        local char2 = polymer_template:sub(i+1, i+1)
        local rule = char1 .. char2

        table.insert(new_polymer_template, char1 .. rules[rule])
    end
    table.insert(new_polymer_template, polymer_template:sub(#polymer_template, #polymer_template))

    new_polymer_template = table.concat(new_polymer_template)

    return new_polymer_template
end

local function do_steps(polymer_template, rules, times)
    local counts_element = {}
    local counts_element_meta = {
        __index = function(tab, key)
            tab[key] = {count = 0, key = key}
            table.insert(tab, tab[key])
            return tab[key]
        end
    }
    setmetatable(counts_element, counts_element_meta)

    for i = 1, times, 1
    do
        polymer_template = do_step(polymer_template, rules)    
    end

    -- Count element:
    for i = 1, #polymer_template, 1
    do
        local element = polymer_template:sub(i, i)
        --print(element)
        counts_element[element].count = counts_element[element].count + 1
    end

    -- Sort element:
    table.sort(counts_element, function(element1, element2)
        return element1.count < element2.count
    end)

    return counts_element[#counts_element].count - counts_element[1].count
end

local polymer_template, rules = load_file(arg[1])
--print(inspect(polymer_template))
--print(inspect(rules))

print(do_steps(polymer_template, rules, 10))