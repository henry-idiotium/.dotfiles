nihil.utils.plugin.require('lspkind', function(lspkind)
	local helpers = require 'helper.lsp'

	lspkind.init {
		-- enables text annotations
		mode = 'symbol',

		-- default symbol map
		-- can be either 'default' (requires nerd-fonts font) or
		-- 'codicons' for codicon preset (requires vscode-codicons font)
		preset = 'codicons',

		-- override preset symbols
		symbol_map = helpers.LSP_ITEM_KINDS,
	}
end)
