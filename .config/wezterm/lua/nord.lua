-- nord

-- repository: https://github.com/barksten/wezterm
-- license: MIT

local M = {}

local palette = {
	-- Polar Night
	nord0 = "#2E3440",
	nord1 = "#3B4252",
	nord2 = "#434C5E",
	nord3 = "#4C566A",
	-- Snow Storm
	nord4 = "#D8DEE9",
	nord5 = "#E5E9F0",
	nord6 = "#ECEFF4",
	--Frost
	nord7 = "#8FBCBB",
	nord8 = "#88C0D0",
	nord9 = "#81A1C1",
	nord10 = "#5E81AC",
	--Aurora
	nord11 = "#BF616A",
	nord12 = "#D08770",
	nord13 = "#EBCB8B",
	nord14 = "#A3BE8C",
	nord15 = "#B48EAD",
}

local active_tab = {
	bg_color = palette.nord8,
	fg_color = palette.nord4,
}

local inactive_tab = {
	bg_color = palette.nord2,
	fg_color = palette.nord5,
}

function M.colors()
	return {
		foreground = palette.nord6,
		background = palette.nord0,
		cursor_bg = palette.nord4,
		cursor_border = palette.nord5,
		cursor_fg = palette.nord1,
		selection_bg = palette.nord2,
		selection_fg = palette.nord6,

		ansi = {
			palette.nord1,
			palette.nord11,
			palette.nord14,
			palette.nord13,
			palette.nord10,
			palette.nord15,
			palette.nord8,
			palette.nord4,
		},

		brights = {
			palette.nord3,
			palette.nord12,
			palette.nord14,
			palette.nord13,
			palette.nord9,
			palette.nord15,
			palette.nord7,
			palette.nord6,
		},

		tab_bar = {
			background = palette.nord1,
			active_tab = active_tab,
			inactive_tab = inactive_tab,
			inactive_tab_hover = active_tab,
			new_tab = inactive_tab,
			new_tab_hover = active_tab,
			inactive_tab_edge = palette.nord4, -- (Fancy tab bar only)
		},
	}
end

function M.window_frame() -- (Fancy tab bar only)
	return {
		active_titlebar_bg = palette.nord0,
		inactive_titlebar_bg = palette.nord0,
	}
end

return M
