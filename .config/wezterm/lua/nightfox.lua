local M = {}
local wezterm = require("wezterm")
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function colors_for_appearance(appearance)
	if appearance:find("Dark") then
		return wezterm.color.get_builtin_schemes()["duskfox"]
	else
		return wezterm.color.get_builtin_schemes()["dawnfox"]
	end
end

local palette = colors_for_appearance(get_appearance())

local active_tab = {
	bg_color = palette.background,
	fg_color = palette.ansi[4],
}

local inactive_tab = {
	bg_color = palette.background,
	fg_color = palette.brights[1],
}
function M.color_scheme()
	return palette
end

function M.colors()
	return {
		foreground = palette.foreground,
		background = palette.background,
		cursor_bg = palette.cursor_bg,
		cursor_border = palette.cursor_border,
		cursor_fg = palette.cursor_fg,
		selection_bg = palette.selection_bg,
		selection_fg = palette.selection_fg,

		ansi = palette.ansi,
		brights = palette.brights,

		tab_bar = {
			background = palette.background,
			active_tab = active_tab,
			inactive_tab = inactive_tab,
			inactive_tab_hover = active_tab,
			new_tab = inactive_tab,
			new_tab_hover = active_tab,
			inactive_tab_edge = palette.forground, -- (Fancy tab bar only)
		},
	}
end

function M.window_frame() -- (Fancy tab bar only)
	return {
		active_titlebar_bg = palette.background,
		inactive_titlebar_bg = palette.forground,
	}
end

return M
