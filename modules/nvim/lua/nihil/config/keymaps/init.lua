return {
    { import = 'nihil.config.keymaps.global' },
    { import = 'nihil.config.keymaps.' .. (vim.g.vscode and 'vscode' or 'neovim') },
}
