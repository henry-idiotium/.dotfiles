--- Code folding helper
return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'luukvbaal/statuscol.nvim',
    },
    event = 'VeryLazy',

    init = function()
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]

        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,

    config = function()
        local ufo = require 'ufo'
        local map_keys = nihil.utils.keymap.map_keys

        map_keys {
            z = {
                ['<s-o>'] = { ufo.openAllFolds, desc = 'Open all folds' },
                ['<s-c>'] = { ufo.closeAllFolds, desc = 'Close all folds' },
                ['m'] = { ufo.closeFoldsWith, desc = 'Close folds with' },
            },
        }

        ufo.setup {
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local new_virt_text = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = ('  %d lines '):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0

                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)

                    if targetWidth > curWidth + chunkWidth then
                        table.insert(new_virt_text, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(new_virt_text, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth) end
                        break
                    end

                    curWidth = curWidth + chunkWidth
                end

                local r_align_appndx = math.max(math.min(vim.opt.textwidth['_value'], width - 1) - curWidth - sufWidth, 0)
                suffix = (' '):rep(r_align_appndx) .. suffix
                table.insert(new_virt_text, { suffix, 'MoreMsg' })

                return new_virt_text
            end,
        }
    end,
}
