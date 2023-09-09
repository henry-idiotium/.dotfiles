local vscode_nvim_exist, vscode_nvim = pcall(require, 'vscode-neovim')
if not vscode_nvim_exist then print 'Missing vscode neovim module' end

local U = nihil.utils
local map_keys = U.keymap.map_keys
local fn = vim.fn

local act = function(name)
    return function(...)
        local a = { ... }
        return function() vscode_nvim[name](a[1], a[2], a[3], a[4], a[5], a[6], a[7]) end
    end
end
local call = act 'notify' ---@type fun(c:string, o?:table): function
local call_range = act 'notify_range' ---@type fun(c:string, l1:number, l2:number, s?:boolean, o?:table): function
local call_range_pos = act 'notify_range_pos' ---@type fun(c:string, l1:number, l2:number, p1:number, p2:number, s?:boolean, o?:table): function

local cursor_move = (function()
    local cmd_id = 'cursorMove'
    local fact = function(to)
        return function(ammount) return call(cmd_id, { to = to, value = ammount or 1, by = 'wrappedLine' }) end
    end
    return { up = fact 'up', down = fact 'down' }
end)()

map_keys {
    k = cursor_move.up(),
    j = cursor_move.down(),
    ['<c-k>'] = cursor_move.up(5),
    ['<c-j>'] = cursor_move.down(5),
    { mode = 'v', ['<c-k>'] = '5k', ['<c-j>'] = '5j' },
    -- ['<c-f>'] = { call 'actions.find', mode = { 'n', 'v' } },

    -- zc = call 'editor.fold',
    -- zo = call 'editor.unfold',
    -- ['z<s-c>'] = call 'editor.foldAll',
    -- ['z<s-o>'] = call 'editor.unfoldAll',
    -- za = call 'editor.toggleFold',
    -- -- ['zf'] = { notify 'editor.createFoldingRangeFromSelection', mode = 'v' },
    -- gd = call 'editor.action.revealDefinition',
    -- ['<s-k>'] = call 'editor.action.showHover',
    -- gpd = call 'editor.action.peekDefinition',
    -- ['g<s-d>'] = call 'editor.action.peekDefinition',
    -- gcc = '<Plug>VSCodeCommentaryLine',
    -- gc = { '<Plug>VSCodeCommentary', mode = { 'x', 'n', 'o' } },
    -- { 'gb', call_range_pos('editor.action.blockComment', fn.line 'v', fn.line '.', fn.getpos('v')[2], fn.getpos('.')[2], true), mode = 'v' },
    -- { 'gb', call_range('editor.action.blockComment', fn.line 'v', fn.line '.', true), mode = 'x' },
}

return {}
