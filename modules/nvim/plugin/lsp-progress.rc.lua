nihil.utils.plugin.setup('lsp-progress', {
	spinner = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' },
	format = function(client_messages)
		return #client_messages > 0
			and table.concat(client_messages, ' ')
			or ''
	end,
	client_format = function(client_name, spinner, series_messages)
		return #series_messages > 0
			and table.concat({ '[', client_name, '] ', spinner, '  ', table.concat(series_messages, ' │ ') }, '')
			or nil
	end,
})
