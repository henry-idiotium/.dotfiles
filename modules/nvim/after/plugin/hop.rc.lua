nihil.utils.plugin.require('hop', function(hop)
	local map_group_keys = nihil.utils.keymap.map_schema_group

	hop.setup {
		key = 'etovxqpdygblzhckisuran',
		multi_windows = true,
		case_insensitive = false,
		quit_key = '<c-q>',
	}

	map_group_keys({ mode = '', remap = true }, {
		{ 'f', hop.hint_char1 },
	})
end, true)
