---@param langs string[]
local function arr_join(langs) return table.concat(langs, ',') end

---@type LazySpec
return {
    'nvimdev/guard.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    config = function()
        local guard_ft = require 'guard.filetype'
        local map_keys = nihil.utils.keymap.map_keys

        -- stylua: ignore
        guard_ft(arr_join({
            'javascript', 'javascriptreact',
            'typescript', 'typescriptreact',
            'html', 'css', 'less', 'scss',
            'yaml', 'yml',
            'markdown',
            'json',
        })):fmt 'prettierd'

        guard_ft('lua'):fmt 'stylua'
        guard_ft('fish'):fmt 'fish_indent'

        require('guard').setup {
            fmt_on_save = false, -- the only options for the setup function
            lsp_as_default_formatter = true, -- Use lsp if no formatter was defined for this filetype
        }

        local trigger_format = function()
            local buf = 0
            local buf_name = vim.api.nvim_buf_get_name(buf)

            local exclude_path = '/node_modules/'
            local exclude_filetypes = { 'sql' }

            if
                -- Disable autoformat on certain filetypes
                vim.tbl_contains(exclude_filetypes, vim.bo[buf].filetype)
                -- Disable autoformat for files in a certain path
                or buf_name:match(exclude_path)
            then
                return
            end

            -- Eslint
            if vim.tbl_contains({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, vim.bo[buf].filetype) then
                -- use nvim built-in
                vim.cmd 'EslintFixAll'
            end

            -- Format
            vim.cmd 'GuardFmt'
        end

        map_keys {
            ['<a-s-f>'] = {
                desc = 'Format buffer (guard-nvim)',
                function()
                    local succeeded, _ = pcall(trigger_format)
                    if not succeeded then
                        local filetype = vim.bo.filetype
                        local message = filetype ~= '' and ('LSP is not support ' .. filetype .. ' file type.') or 'LSP is not supported!'
                        print(message .. ' (please checkout, it might be an EXCEPTION)')
                    end
                end,
            },
        }
    end,
}
