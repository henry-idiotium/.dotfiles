---@diagnostic disable: no-unknown
local wezterm = require("wezterm")
local act = wezterm.action

local fonts = {
	iosevka_wizard = "IosevkaWizard Nerd Font",
	segoe_ui_emoji = "Segoe UI Emoji",
	firacode = "FiraCode Nerd Font",
	Ligamononoki = "Ligamononoki Nerd Font",
	operator_mono = "OperatorMonoLig Nerd Font",
}
local themes = {
	cat = "Catppuccin Mocha",
	rose_pine = "rose-pine-moon",
	nightowl = "Night Owl (Gogh)",
	nebula = "Nebula (base16)",
	rouge = "Rouge 2",
	palenight = "Palenight (Gogh)",
	material = "Material Darker (base16)",
	nord = "Nord (Gogh)",
	tmr_nite_burns = "Tomorrow Night Burns", -- Very RED
	nightly = "Nightfly (Gogh)",
	nucolors = "Nucolors (terminal.sexy)",
	ocean_dark = "Ocean Dark (Gogh)",
	operator_mono = "Operator Mono Dark",
	overnight = "Overnight Slumber",
	poimandres = "Poimandres Storm",
}

return {
	default_prog = {
		"arch.exe",
		-- 'pwsh.exe',
	},

	---- Window
	-- enable_wayland = true,
	-- front_end = 'OpenGL',
	max_fps = 120,
	animation_fps = 60,
	initial_cols = 130,
	initial_rows = 22,
	window_decorations = "RESIZE", -- TITLE RESIZE INTEGRATED_BUTTONS NONE
	window_background_opacity = 0.9,
	win32_system_backdrop = "Auto", -- Auto Mica Tabbed Acrylic Disabled
	win32_acrylic_accent_color = "#000000",
	window_padding = { top = 0, bottom = 0, left = 0, right = 0 },
	warn_about_missing_glyphs = false,

	---- Font ____
	-- NOTE: combination between font_size and line_height may "cut off" font char height
	font_size = 12,
	cell_width = 1,
	line_height = 1.5,
	font = wezterm.font_with_fallback({
		fonts.iosevka_wizard,
		fonts.segoe_ui_emoji,
	}),

	use_cap_height_to_scale_fallback_fonts = true,
	allow_square_glyphs_to_overflow_width = "Always", -- Never, WhenFollowedBySpace, Always
	harfbuzz_features = {
		"calt",
		"clig",
		"dlig",
		"liga",
		"ss01",
		"ss02",
		"ss03",
		"ss04",
		"ss05",
		"ss06",
		"ss10",
		"ss11",
		"ss12",
		"zero=0",
		"onum=0",
	},
	unicode_version = 15,
	custom_block_glyphs = true,
	underline_thickness = 1,
	underline_position = -6,

	-- Freetype
	freetype_load_flags = "FORCE_AUTOHINT",
	freetype_load_target = "Light",
	freetype_render_target = "Light",

	---- Theme
	enable_tab_bar = false,
	color_scheme = themes.cat,
	colors = { background = "#000000" },

	---- Keymaps
	disable_default_key_bindings = true,
	keys = {
		-- toggle modes
		{ key = "F12", mods = "NONE", action = act.ShowDebugOverlay },
		{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },

		-- resizability
		{ key = "+", mods = "SUPER|SHIFT", action = act.IncreaseFontSize },
		{ key = "_", mods = "SUPER|SHIFT", action = act.DecreaseFontSize },
		{ key = ")", mods = "SUPER|ALT|SHIFT", action = act.ResetFontSize },

		-- copy/paste
		{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
		{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
		{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },

		-- Send keybind to shell
		{ mods = "CTRL", key = "Tab", action = act.SendKey({ mods = "CTRL", key = "Tab" }) },
		{ mods = "CTRL|SHIFT", key = "Tab", action = act.SendKey({ mods = "CTRL|SHIFT", key = "Tab" }) },
		{ mods = "CTRL", key = ";", action = act.SendKey({ mods = "ALT|SHIFT", key = "|" }) },
		-- { mods = 'CTRL', key = ';', action = act.SendKey { mods = 'CTRL', key = '\\' } },
		-- { mods = 'CTRL|ALT', key = ';', action = act.SendKey { mods = 'CTRL|ALT', key = '\\' } },
	},
}
