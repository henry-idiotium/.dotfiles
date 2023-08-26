local M = {}

-- local function disable(enable_in_vscode)
--     return enable_in_vscode ~= true and vim.g.vscode == 1
-- end

--- Safely require plugin.
--
---@param name     string
---@param callback function
function M.require(name, callback)
    local present, plug = pcall(require, name)

    if not present and nihil.user.log_error then
        print(string.format('"%s" is not installed!', name))
        return
    end

    callback(plug)
end

--- Import a table.
--
---@param prefix      string|nil
---@param path_table  table
function M.requires(prefix, path_table)
    prefix = prefix or ''

    for _, path in ipairs(path_table) do
        local import_path = prefix .. path
        require(import_path)
    end
end

--- Setup plugin config safely.
--
---@param name    string
---@param config  table
function M.setup(name, config)
    M.require(name, function(plug)
        if plug.setup then
            plug.setup(config)
        end
    end)
end

--: Theme
local function _is_match_theme(theme_name)
    local global_theme = nihil.user.theme
    return global_theme and (global_theme == theme_name)
end

--- Safely require theme.
--
---@param name     string
---@param callback function
function M.theme_require(name, callback)
    if not _is_match_theme(name) then return end

    M.require(name, callback)
    vim.cmd.colorscheme(name)
end

--- Setup theme safely.
--
---@param name   string
---@param config table
function M.theme_setup(name, config)
    M.theme_require(name, function(plug)
        if not plug.setup then return end

        plug.setup(config)
    end)
end

nihil.utils.plugin = M
