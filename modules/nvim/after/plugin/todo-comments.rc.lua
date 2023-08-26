nihil.utils.plugin.require('todo-comments', function (todo_comments)
	local map_keys         = nihil.utils.keymap.map_schema
	local map_group_keys   = nihil.utils.keymap.map_schema_group
	local cat_mocha_colors = require 'catppuccin.palettes'.get_palette 'mocha'

	local color_error      = cat_mocha_colors.red or '#F38BA8'
	local color_warn       = cat_mocha_colors.yellow or '#F9E2AF'
	local color_info       = cat_mocha_colors.green or '#A6E3A1'
	local color_hint       = cat_mocha_colors.blue or '#94E2D5'
	local color_default    = cat_mocha_colors.mauve or '#CBA6F7'
	local color_test       = cat_mocha_colors.lavender or '#F5C2E7'

	todo_comments.setup {
		signs = false, -- show icons in the signs column
		sign_priority = 8, -- sign priority
		-- keywords recognized as todo comments

		-- list of named colors where we try to extract the guifg from the
		-- list of highlight groups or use the hex color if hl not found as a fallback
		colors = {
			info    = { color_info, 'DiagnosticInfo' },
			hint    = { color_hint, 'DiagnosticHint', },
			warn    = { 'DiagnosticWarn', 'WarningMsg', color_warn },
			error   = { 'DiagnosticError', 'ErrorMsg', color_error },
			depr    = { 'DiagnosticError', 'ErrorMsg', color_error },
			test    = { 'Identifier', color_test },
			default = { 'Identifier', color_default },
		},
		keywords = {
			TODO = { icon = ' ', color = 'info' },
			NOTE = { icon = '󰎞 ', color = 'hint', alt = { 'INFO' } },
			WARN = { icon = ' ', color = 'warn', alt = { 'WARNING', 'XXX' } },
			FIX = {
				icon = ' ', -- icon used for the sign, and in search results
				color = 'error', -- can be a hex color, or a named color (see below)
				alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			TEST = { icon = '󰙨', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
			DEPR = { icon = '󰟢', color = 'depr', alt = { 'DEPRECATED' } },
		},
		gui_style = {
			fg = 'BOLD', -- The gui style to use for the fg highlight group.
			bg = 'BOLD', -- The gui style to use for the bg highlight group.
		},
		merge_keywords = true, -- when true, custom keywords will be merged with the defaults

		-- highlighting of the line containing the todo comment
		-- * before: highlights before the keyword (typically comment characters)
		-- * keyword: highlights of the keyword
		-- * after: highlights after the keyword (todo text)
		highlight = {
			multiline = true, -- enable multine todo comments
			multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
			multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
			before = '', -- 'fg' or 'bg' or empty
			keyword = 'fg', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
			after = '', -- 'fg' or 'bg' or empty
			pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
			comments_only = true, -- uses treesitter to match keywords in comments only
			max_line_len = 400, -- ignore lines longer than this
			exclude = { 'todo-comments.rc.lua' }, -- list of file types to exclude highlighting
		},

		search = {
			command = 'rg',
			args = {
				'--color=never',
				'--no-heading',
				'--with-filename',
				'--line-number',
				'--column',
			},
			-- regex that will be used to match keywords.
			-- don't replace the (KEYWORDS) placeholder
			pattern = [[\b(KEYWORDS):]], -- ripgrep regex
			-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
		},
	}

	map_keys {
		{ ']t', todo_comments.jump_next, desc = 'Next todo comment' },
		{ '[t', todo_comments.jump_prev, desc = 'Previous todo comment' },
	}

	map_group_keys({ prefix = '<leader>t', name = 'Todo comments' }, {
		{ 'q', '<cmd>TodoLocList<cr>',   desc = 'Search hl comments in qf' },
		{ 't', '<cmd>TodoTelescope<cr>', desc = 'Search hl comments in telescope' },
	})
end)
