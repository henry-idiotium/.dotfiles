nihil.utils.plugin.require('packer', function(packer)
    local packer_cmd = 'packadd packer.nvim'
    vim.cmd(packer_cmd)

    -- Core plugins
    local plugins = {
        'wbthomason/packer.nvim',

        'nvim-lua/plenary.nvim', -- Common utilities
        'lewis6991/impatient.nvim',

        -- Language support protocol
        'neovim/nvim-lspconfig',
        'jose-elias-alvarez/null-ls.nvim',     -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
        'nvimdev/lspsaga.nvim',
        'ray-x/lsp_signature.nvim',            -- Better UI for LSP's signature help
        'L3MON4D3/LuaSnip',                    -- Snippets
        'onsails/lspkind-nvim',                -- vscode-like pictograms
        {
            'nvim-treesitter/nvim-treesitter', -- Code highlighter
            requires = 'nvim-treesitter/nvim-treesitter-textobjects',
            run = function() require 'nvim-treesitter.install'.update { with_sync = true } end,
        },
        {
            'numToStr/Comment.nvim',
            requires = 'JoosepAlviste/nvim-ts-context-commentstring',
        },
        'gpanders/editorconfig.nvim',
        'linrongbin16/lsp-progress.nvim',

        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Completion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',               -- nvim-cmp source for neovim's built-in LSP
        'hrsh7th/cmp-buffer',                 -- nvim-cmp source for buffer words
        'hrsh7th/cmp-cmdline',                -- nvim-cmp source for vim's cmdline
        'lukas-reineke/cmp-under-comparator', -- nvim-cmp soter provider

        -- XML tags completion
        'windwp/nvim-autopairs',
        'windwp/nvim-ts-autotag',

        -- Wrapper utils (parentheses, brackets, quotes, XML tags, etc.)
        'kylechui/nvim-surround',
        'abecodes/tabout.nvim',      -- Move cursor out of wrapper
        {
            'kevinhwang91/nvim-ufo', -- Code folding helper
            requires = {
                'kevinhwang91/promise-async',
                'luukvbaal/statuscol.nvim',
            },
        },

        -- Utility popup modals
        {
            'nvim-telescope/telescope.nvim',
            requires = { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
        'nvim-telescope/telescope-file-browser.nvim',
        'LukasPietzschmann/telescope-tabs',

        -- Git
        'lewis6991/gitsigns.nvim',
        'sindrets/diffview.nvim',

        -- dev experience
        { 'catppuccin/nvim',  as = 'catppuccin', }, -- Default theme
        'folke/todo-comments.nvim',                 -- Comment highlighter
        'folke/which-key.nvim',                     -- Display popup of keybinds
        'kyazdani42/nvim-web-devicons',             -- File icons
        'norcalli/nvim-colorizer.lua',              -- Highlight color for hex value
        'hoob3rt/lualine.nvim',                     -- Status line
        'lukas-reineke/indent-blankline.nvim',      -- Indentation highlight
        -- 'RRethy/vim-illuminate', -- cursor-line

        { 'phaazon/hop.nvim', branch = 'v2', }, -- Ease navigation through buffer (easy motion)
    }

    packer.startup(function(use)
        if next(nihil.user.plugins) then
            plugins = vim.tbl_extend('keep', plugins, nihil.user.plugins)
        end

        for _, plug in pairs(plugins) do use(plug) end
    end)
end)
