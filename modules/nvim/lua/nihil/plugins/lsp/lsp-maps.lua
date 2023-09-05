local map_keys = nihil.utils.keymap.map_keys

map_keys {
    ['<s-k>'] = { '<cmd>Lspsaga hover_doc<cr>', desc = 'Show documentation' },

    -- ['<a-s-f>'] = { vim.lsp.buf.format, desc = 'Lsp built-in formatter' }, -- use guard.nvim
    ['<c-.>'] = { '<cmd>Lspsaga code_action<cr>', desc = 'Show code actions' },

    gi = { vim.lsp.buf.implementation, desc = 'Go to Implementation' },
    gd = { '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to definition' },

    gp = {
        desc = 'Peek lsp',
        d = { '<cmd>Lspsaga peek_definition<cr>', desc = 'Peek definition' },
        f = { '<cmd>Lspsaga finder<cr>', desc = 'Show definition and references' },
    },

    [']d'] = { '<cmd>Lspsaga diagnostic_jump_next<cr>', desc = 'Go to next diagnostics' },
    ['[d'] = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', desc = 'Go to previous diagnostics' },

    ['<space>r'] = {
        desc = 'Rename stuffs',
        ['n'] = { '<cmd>Lspsaga rename<cr>', desc = 'Rename symbol' },
    },

    ['<space>t'] = {
        desc = 'Toggle things',
        l = {
            desc = 'Toggle LSP',
            d = { '<cmd>LspDiagnosticToggle<cr>', desc = 'Toggle diagnostic' },
            f = { '<cmd>LspAutoFormatToggle<cr>', desc = 'Toggle format on save' },
        },
        g = {
            desc = 'Toggle diagnostic',
            d = { '<cmd>Lspsaga show_cursor_diagnostics<cr>', desc = 'Show diagnostics of current line' },
            ['<s-d>'] = { '<cmd>Lspsaga show_buf_diagnostics<cr>', desc = 'Show diagnostics of active file' },
        },
    },
}

return {}
