--- NOTE:
-- timeout (h timeout) when **WhichKey** opens is controlled by the vim setting timeoutlen.
-- Please refer to the documentation to properly set it up. Setting it to `0`, will effectively
-- always show **WhichKey** immediately, but a setting of `500` (500ms) is probably more appropriate.
--
-- Don't create any keymappings yourself to trigger WhichKey. Unlike with _vim-which-key_, we do this fully automatically.
-- Please remove any left-over triggers you might have from using _vim-which-key_.
--
-- Run `:checkhealth which_key` to see if there's any conflicting keymaps that will prevent triggering **WhichKey**
return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        window = {
            -- none, single, double, shadow
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            position = 'bottom',     -- bottom, top
            margin = { 1, 3, 2, 3 }, -- extra window margin [top, right, bottom, left]
        },
        layout = {
            align = 'center', -- align columns left, center or right
        },
    },
}
