nihil.utils.plugin.require('lspconfig', function()
	local lsp            = vim.lsp
	local kb             = nihil.utils.keymap
	local map_keys       = kb.map_schema
	local map_group_keys = kb.map_schema_group
	local lsp_sig        = require 'lsp_signature'

	map_keys {
		{ '<s-k>',     '<cmd>Lspsaga hover_doc<cr>',               desc = 'Show documentation' },
		{
			'<c-a-s-k>',
			lsp_sig.toggle_float_win,
			desc = 'Toggle signature float window',
			mode = { 'i', 'n' },
		},
		{
			'<c-a-k>',
			vim.lsp.buf.signature_help,
			desc = 'Toggle signature',
			mode = { 'i', 'n' },
		},

		{ 'gi',        lsp.buf.implementation,                     desc = 'Go to Implementation' },
		{ 'gd',        '<cmd>Lspsaga goto_definition<cr>',         desc = 'Go to definition' },

		{ '<a-s-k>',   '<cmd>Lspsaga show_cursor_diagnostics<cr>', desc = 'Show diagnostic under cursor' },
		{ '<c-a-s-k>', '<cmd>Lspsaga show_buf_diagnostics<cr>',    desc = 'Show diagnostic under cursor' },
		{ ']d',        '<cmd>Lspsaga diagnostic_jump_next<cr>',    desc = 'Go to next diagnostics', },
		{ '[d',        '<cmd>Lspsaga diagnostic_jump_prev<cr>',    desc = 'Go to previous diagnostics', },

		{ '<a-s-f>',   lsp.buf.format,                             desc = 'Format buffer', },
	}

	map_group_keys({ prefix = 'gp', name = 'Show Lsp peek' }, {
		{ 'd', '<cmd>Lspsaga peek_definition<cr>', desc = 'Peek definition' },
		{ 'f', '<cmd>Lspsaga lsp_finder<cr>',      desc = 'Show definition and references', },
	})

	map_group_keys({ prefix = '<leader>r', name = 'Rename actions' }, {
		{ 'n', '<cmd>Lspsaga rename<cr>', desc = 'Rename symbol' },
	})

	map_group_keys({ prefix = '<leader>c', name = 'Code actions' }, {
		{ 'a', '<cmd>Lspsaga code_action<cr>', desc = 'Show code actions' },
	})

	map_group_keys({ prefix = '<leader>l', name = 'LSP server actions' }, {
		{ 'd', '<cmd>LspDiagnosticToggle<cr>', desc = 'Toggle diagnostic', },
		{ 'f', '<cmd>LspAutoFormatToggle<cr>', desc = 'Toggle format on save', },
	})
end)
