---@diagnostic disable: undefined-field
return {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
        'L3MON4D3/LuaSnip',
        'onsails/lspkind-nvim',
        'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
        'hrsh7th/cmp-buffer', -- nvim-cmp source for buffer words
        'hrsh7th/cmp-cmdline', -- nvim-cmp source for vim's cmdline
        'lukas-reineke/cmp-under-comparator', -- nvim-cmp soter provider
    },
    config = function()
        local cmp = require 'cmp'
        local lspkind = require 'lspkind'
        local luasnip = require 'luasnip'

        local function format_for_tailwind(entry, vim_item)
            if vim_item.kind == 'Color' and entry.completion_item.documentation then
                local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
                if r then
                    local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
                    local group = 'Tw_' .. color
                    if vim.fn.hlID(group) < 1 then vim.api.nvim_set_hl(0, group, { fg = '#' .. color }) end
                    vim_item.kind = '●'
                    vim_item.kind_hl_group = group
                    return vim_item
                end
            end

            vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind

            return vim_item
        end

        cmp.setup {
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<c-d>'] = cmp.mapping.scroll_docs(-4),
                ['<c-u>'] = cmp.mapping.scroll_docs(4),
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-e>'] = cmp.mapping.close(),
                ['<cr>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<tab>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },

                ['<c-j>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<c-k>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },

            ---@diagnostic disable-next-line: undefined-field
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'luasnip' },
            },

            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = (function()
                    local function before(entry, vim_item)
                        vim_item = format_for_tailwind(entry, vim_item)
                        return vim_item
                    end

                    return function(entry, vim_item)
                        local format = lspkind.cmp_format { mode = 'symbol_text', before = before }(entry, vim_item)
                        local info = vim.split(format.kind, '%s', { trimempty = true })
                        local menu = table.concat { info[2] or '', info[3] or '' }

                        format.kind = (info[1] and string.format('%s', info[1]) or ' ') .. '  '
                        format.menu = (menu ~= '') and string.format('    (%s) ', menu) or ''

                        return format
                    end
                end)(),
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        }

        local preset_map = cmp.mapping.preset.cmdline()
        local map_select_next = preset_map['<Tab>']
        local map_select_prev = preset_map['<S-Tab>']
        local map_buffer_close = preset_map['<C-E>']

        cmp.setup.cmdline(':', {
            mapping = {
                ['<tab>'] = map_select_next,
                ['<s-tab>'] = map_select_prev,
                ['<c-e>'] = map_buffer_close,
            },
            sources = cmp.config.sources({ { name = 'path' } }, {
                {
                    name = 'cmdline',
                    option = { ignore_cmds = { 'Man', '!' } },
                },
            }),
            formatting = {
                fields = { 'abbr' },
                format = lspkind.cmp_format { maxwidth = 50 },
            },
        })

        vim.cmd [[
            set completeopt=menuone,noinsert,noselect
            highlight! default link CmpItemKind CmpItemMenuDefault
        ]]
    end,
}
