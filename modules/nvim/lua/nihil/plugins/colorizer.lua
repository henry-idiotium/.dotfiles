return {
    'norcalli/nvim-colorizer.lua',
    ft = (require 'nihil.helpers.lsp' or {}).FILE_TYPES,
    opts = { '*' },
}
