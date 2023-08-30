local M = {}

--- Add/Override highlights ColorScheme highlight
-- Example:
--```lua
-- local override_hl_schema = {
--     DiagnosticUnderlineHint = opts
-- }
--```
-- `opts` accepted the following keys
--     fg, bg, sp     color name or #RRGGBB
--     blend          integer between 0 and 100
--     bold           boolean
--     italic         boolean
--     standout       boolean
--     underline      boolean
--     undercurl      boolean
--     underdouble    boolean
--     underdotted    boolean
--     underdashed    boolean
--     strikethrough  boolean
--     reverse        boolean
--     nocombine      boolean
--     link           name of another highlight group to link to, see hi-link.
--     default        Don't override existing definition hi-default
--     ctermfg        Sets foreground of cterm color ctermfg
--     ctermbg        Sets background of cterm color ctermbg
--     cterm          cterm attribute map, like highlight-args. If not set, cterm attributes will match those from the attribute map documented above.
--
---@param hl_colorscheme table
function M.add_on_colorscheme(hl_colorscheme)
    local EVENT_NAME = 'ColorScheme'
    local GROUP_NAME = 'UserColors'
    local PATTERN    = '*'

    local au_group   = vim.api.nvim_create_augroup(GROUP_NAME, { clear = false })

    local function callback()
        for hl_name, opts in pairs(hl_colorscheme) do
            vim.api.nvim_set_hl(0, hl_name, opts or {})
        end
    end

    vim.api.nvim_create_autocmd(EVENT_NAME, {
        group = au_group,
        pattern = PATTERN,
        callback = callback,
    })
end

nihil.utils.highlight = M

return {}
