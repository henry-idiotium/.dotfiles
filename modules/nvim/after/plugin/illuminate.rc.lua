--[[ nihil.utils.plugin.require('illuminate', function(illuminate)
	-- default configuration
	illuminate.configure {
		-- providers: provider used to get references in the buffer, ordered by priority
		providers = {
			'lsp',
			'treesitter',
			'regex',
		},
		-- delay: delay in milliseconds
		delay = 100,
		min_count_to_highlight = 2,
	}
end) ]]
