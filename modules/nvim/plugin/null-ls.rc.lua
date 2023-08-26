nihil.utils.plugin.require('null-ls', function(null_ls)
	local helpers = require 'helper.lsp'

	null_ls.setup {
		sources = {
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.code_actions.eslint_d,
			null_ls.builtins.diagnostics.eslint_d.with {
				diagnostics_format = '[eslint] #{m}\n(#{c})',
			},
		},
		on_attach = function(client, bufnr)
			helpers.auto_format.null_ls(client, bufnr)
		end,
	}
end)
