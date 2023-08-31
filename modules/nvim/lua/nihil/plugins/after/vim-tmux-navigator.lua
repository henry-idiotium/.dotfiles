return {}
--[[ local run = nihil.utils.cmd.callbackRun

---@type LazySpec
return {
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
    init = function() vim.api.nvim_set_var('tmux_navigator_no_mappings', 1) end,
    keys = {
        { '<c-a-k>', run 'TmuxNavigateUp', desc = 'Navigate Up Tmux', id = 'key_TmuxNavigateUp' },
        { '<c-a-l>', run 'TmuxNavigateLeft', desc = 'Navigate Left Tmux', id = 'key_TmuxNavigateLeft' },
        { '<c-a-j>', run 'TmuxNavigateDown', desc = 'Navigate Down Tmux', id = 'key_TmuxNavigateDown' },
        { '<c-a-h>', run 'TmuxNavigateRight', desc = 'Navigate RightTmux', id = 'key_TmuxNavigateRight' },
    },
} ]]
