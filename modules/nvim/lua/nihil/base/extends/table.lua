local M = {}

--- Get table keys.
---@param tbl table
function M.get_keys(tbl)
    local keyset = {}
    local n = 0

    for k, _ in pairs(tbl) do
        n = n + 1
        keyset[n] = k
    end

    return keyset
end

nihil.utils.table = M
nihil.utils.tbl = M

return {}

