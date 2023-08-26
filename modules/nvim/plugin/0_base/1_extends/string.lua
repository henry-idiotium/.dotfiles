local M = {}

--- Split string with provided seperator
---@param str string
---@param sep string
---@return table
function M.split(str, sep)
    sep = sep or '' -- %s

    local result = {}
    local pattern = sep ~= '' and "(%[^" .. sep .. "%]+)" or '(.)'

    for s in string.gmatch(str, pattern) do
        table.insert(result, s)
    end

    return result
end

nihil.utils.string = M
nihil.utils.str = M
