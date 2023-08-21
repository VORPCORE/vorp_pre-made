---@class UtilityService
---@field Table_equals fun(o1: any, o2: any, ignore_mt: boolean): boolean
---@field Table_contains fun(o1: any, o2: any): boolean
---@field Table_MergeTable fun(t1: table, t2: table): table
---@field IsValueInArray fun(value: any,array:table): boolean
SharedUtils = {}

function SharedUtils.Table_equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end

    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or SharedUtils.Table_equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end

    return true
end

function SharedUtils.Table_contains(o1, o2)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)

    if o1Type ~= o2Type then
        return false
    end

    if o1Type ~= 'table' or o2Type ~= 'table' then
        return false
    end

    for key2, value2 in pairs(o2) do
        local value1 = o1[key2]
        if value1 == nil or not SharedUtils.Table_equals(value1, value2, true) then
            return false
        end
    end

    return true
end

--- merge two tables together
---@param a any
---@param b any
---@return table
function SharedUtils.MergeTables(a, b)
    a = type(a) == 'string' and json.decode(a) or a
    b = type(b) == 'string' and json.decode(b) or b

    local newTable = {}
    for key, value in pairs(a) do
        newTable[key] = value
    end
    for key, value in pairs(b) do
        newTable[key] = value
    end
    return newTable
end

--- check if a value is in a array
---@param value string| number
---@param array table
---@return boolean
function SharedUtils.IsValueInArray(value, array)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end
