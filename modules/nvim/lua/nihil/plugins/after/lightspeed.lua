--- Easy navigation
return {
    'ggandor/lightspeed.nvim',
    dependencies = 'tpope/vim-repeat',
    opts = {
        ignore_case = false,

        --- s/x ---
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = false,
        -- Display characters in a custom way in the highlighted matches.
        substitute_chars = { ['\r'] = '┬¼', },
        -- Leaving the appropriate list empty effectively disables "smart" mode,
        -- and forces auto-jump to be on or off.
        -- safe_labels = {},
        -- labels = {},

        --- f/t ---
        limit_ft_matches = 4,
        repeat_ft_with_target_char = false,
    }
}

