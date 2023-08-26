--- NOTE:
-- timeout (h timeout) when **WhichKey** opens is controlled by the vim setting timeoutlen.
-- Please refer to the documentation to properly set it up. Setting it to `0`, will effectively
-- always show **WhichKey** immediately, but a setting of `500` (500ms) is probably more appropriate.
--
-- don't create any keymappings yourself to trigger WhichKey. Unlike with _vim-which-key_, we do this fully automatically.
-- Please remove any left-over triggers you might have from using _vim-which-key_.
--
-- You can run `:checkhealth which_key` to see if there's any conflicting keymaps that will prevent triggering **WhichKey**
nihil.utils.plugin.setup('which-key', {
	window = {
		-- none, single, double, shadow
		border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
		position = 'bottom', -- bottom, top
		margin = { 1, 3, 2, 3 }, -- extra window margin [top, right, bottom, left]
	},
	layout = {
		align = 'center', -- align columns left, center or right
	},
})
