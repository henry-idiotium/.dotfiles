--- Better UI for LSP's signature help
return {
    'ray-x/lsp_signature.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    keys = {
        { '<c-s-k>', vim.lsp.buf.signature_help, desc = 'Toggle signature', mode = { 'i', 'n' } },
    },
    opts = {
        bind = true,
        always_trigger = false,
        close_timeout = 4000,
        floating_window = false,

        hint_enable = true,
        hint_prefix = '󰁔 ',

        padding = ' ',
        transparency = nil, -- set to nil to disable
        shadow_blend = 36, -- if you using shadow as border use this set the opacity

        hi_parameter = 'LspSignatureActiveParameter',
        handler_opts = { border = 'rounded' }, -- double, rounded, single, shadow, none, or a table of borders

        move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
        toggle_key = '<a-s-k>', -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
        select_signature_key = '<a-n>', -- cycle to next signature, e.g. '<M-n>' function overloading
    },
}
