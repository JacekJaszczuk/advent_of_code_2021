#!/usr/bin/env lua5.4

local json = require("dkjson")
local inspect = require("inspect")

print("Day 4, task 1!")

local function load_file(filename)
    local ret = {}

    local f = io.open(filename)

    -- Read generater numbers:
    ret.numbers = json.decode("{"..f:read("l").."}")

    -- Read boards:
    local board_number = 1
    local i = 1
    ret.boards = {}
    for number in f:lines("n")
    do
        if not ret.boards[board_number]
        then
            ret.boards[board_number] = {}
        end
        ret.boards[board_number][i] = number
        i = i + 1
        if i == 26
        then
            i = 1
            board_number = board_number + 1
        end
    end

    --print(inspect(ret))

    f:close()

    return ret
end

local function check_win(present_number_board)
    -- Check 1, 2, 3, 4, 5 row:
    local p = present_number_board
    if p[1] and p[2] and p[3] and p[4] and p[5]
    then
        return true
    elseif p[6] and p[7] and p[8] and p[9] and p[10]
    then
        return true
    elseif p[11] and p[12] and p[13] and p[14] and p[15]
    then
        return true
    elseif p[16] and p[17] and p[18] and p[19] and p[20]
    then
        return true
    elseif p[21] and p[22] and p[23] and p[24] and p[25]
    then
        return true
    -- Check 1, 2, 3, 4, 5 columns:
    elseif p[1] and p[6] and p[11] and p[16] and p[21]
    then
        return true
    elseif p[2] and p[7] and p[12] and p[17] and p[22]
    then
        return true
    elseif p[3] and p[8] and p[13] and p[18] and p[23]
    then
        return true
    elseif p[4] and p[9] and p[14] and p[19] and p[24]
    then
        return true
    elseif p[5] and p[10] and p[15] and p[20] and p[25]
    then
        return true
    else
        return false
    end
end

local function find_and_mark_number(number_to_check, board, present_number_board)
    for i, number in ipairs(board)
    do
        if number == number_to_check
        then
            present_number_board[i] = true
            return
        end
    end
end

local function check_bingo(numbers, boards)

    -- Make present number table:
    local present_number_boards = {}
    for i = 1, #boards, 1
    do
        present_number_boards[i] = {}
    end

    -- Do bingo:
    local win_board
    local win_number
    for i, number in ipairs(numbers)
    do
        print(number)
        -- Check boards:
        for j, board in ipairs(boards)
        do
            find_and_mark_number(number, board, present_number_boards[j])
        end

        -- Check who wins if wins:
        for j, present_number_board in ipairs(present_number_boards)
        do
            if check_win(present_number_board)
            then
                win_board = j
                break
            end
        end

        if win_board
        then
            win_number = number
            break
        end
    end

    -- Calc win board:
    -- Sum unmarked:
    local sum_unmarked = 0
    for i = 1, 25, 1
    do
        if not present_number_boards[win_board][i]
        then
            sum_unmarked = sum_unmarked + boards[win_board][i]
        end
    end

    print("Answer:", sum_unmarked * win_number)
    
end

local bingo = load_file(arg[1])
check_bingo(bingo.numbers, bingo.boards)