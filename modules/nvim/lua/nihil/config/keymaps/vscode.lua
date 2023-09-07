local vscode_nvim_exist, vscode_nvim = pcall(require, 'vscode-neovim')
if not vscode_nvim_exist then print 'Missing vscode neovim module' end

local K = nihil.utils.keymap
local map_keys = K.map_keys

local actions = {
    notify = function(cmd)
        return function() vscode_nvim.notify(cmd) end
    end,
    call = function(cmd)
        return function() vscode_nvim.call(cmd) end
    end,
}

map_keys {
    ['zc'] = { actions.notify 'editor.fold' },
    ['zo'] = { actions.notify 'editor.unfold' },
    ['z<s-c>'] = { actions.notify 'editor.foldAll' },
    ['z<s-o>'] = { actions.notify 'editor.unfoldAll' },
    ['za'] = { actions.notify 'editor.toggleFold' },
    ['zf'] = { actions.notify 'editor.createFoldingRangeFromSelection', mode = 'v' },

    ['gd'] = { 'vscodeGoToDefinition' },
    ['<s-k>'] = { actions.notify 'editor.action.showHover' },
    ['gpd'] = { actions.notify 'editor.action.peekDefinition' },
    ['g<s-d>'] = { actions.notify 'editor.action.peekDefinition' },

    ['<c-f>'] = { actions.notify 'actions.find', mode = { 'n', 'v' } },
}

-- Better movement
local function move_cursor(amount, dir)
    return function()
        local is_fold = (vim.fn.reg_recording() == '') and (vim.fn.reg_executing() == '')
        return (amount or '') .. (is_fold and ('g' .. dir) or dir)
    end
end
map_keys({
    { 'j', move_cursor(1, 'j') },
    { 'k', move_cursor(1, 'k') },
    { '<c-j>', move_cursor(5, 'j') },
    { '<c-k>', move_cursor(5, 'k') },
}, { mode = { 'n', 'v' }, expr = true, remap = true })

return {}
