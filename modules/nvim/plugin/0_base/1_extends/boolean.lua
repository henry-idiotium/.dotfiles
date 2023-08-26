local M = {}


--NOTE: this is the quickest way to parse value in lua
local COERCE_BOOLEAN_MAP = {
    [1]       = true,
    [0]       = false,
    [true]    = true,
    [false]   = false,
    ['true']  = true,
    ['false'] = false,
    ['True']  = true,
    ['False'] = false,
}

--- Convert any value to boolean
---@param value any
---@return boolean
function M.parse(value)
    local result = COERCE_BOOLEAN_MAP[value]
    if type(result) == 'boolean' then
        error(value .. ' is not parsable!', 1)
    end
    return result
end

nihil.utils.boolean = M
nihil.utils.bool = M
