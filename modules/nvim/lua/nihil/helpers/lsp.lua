---@diagnostic disable: unused-local
local M = {}

local api = vim.api

------------------
-- Constants
------
M.AUGROUPS = {
    LSP = 'LspFormat',
}
M.LSP_ITEM_KINDS = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = ' ',
}
M.FILE_TYPES = {
    'html',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'sass',
    'scss',
    'json',
    'jsonc',
    'markdown',
    'python',
    'lua',
}

------------------
-- Auto Command
------
M.auto_format = {}

M.lsp_auto_format = function(client, bufnr)
    if not client.server_capabilities.documentFormattingProvider then return end

    api.nvim_create_autocmd('BufWritePre', {
        group = api.nvim_create_augroup(M.AUGROUPS.LSP, { clear = true }),
        buffer = bufnr,
        callback = function() vim.lsp.buf.format { bufnr = bufnr } end,
    })
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
    -- M.lsp_auto_format(client, bufnr)
    if vim.g.logging_level == 'debug' then
        local msg = string.format('Language server %s started!', client.name)
        vim.notify(msg, vim.log.levels.DEBUG, { title = 'Nvim-Lsp-Config' })
    end
end

return M
