local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Spawn a fish shell in login mode
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local theme = require("lua/nightfox")
config.color_schemes = {
	["My Default"] = theme.color_scheme(),
}
config.color_scheme = "My Default"
config.window_frame = theme.window_frame()
config.colors = theme.colors()

local function update_background(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	local colors = theme.colors()
	if window_dims.is_full_screen then
		if not overrides.macos_window_background_blur and overrides.window_background_opacity then
			-- not changing anything
			return
		end
		overrides.macos_window_background_blur = nil
		overrides.window_background_opacity = nil

		colors.tab_bar.background = "black"
		colors.tab_bar.active_tab.bg_color = "black"
		colors.tab_bar.inactive_tab.bg_color = "black"
	else
		overrides.window_background_opacity = 0.90
		overrides.macos_window_background_blur = 20
		colors.tab_bar.background = colors.background
		colors.tab_bar.active_tab.bg_color = colors.background
		colors.tab_bar.inactive_tab.bg_color = colors.background
	end
	overrides.colors = colors

	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, pane)
	update_background(window)
end)

wezterm.on("window-config-reloaded", function(window)
	update_background(window)
end)

config.window_decorations = "RESIZE"
config.integrated_title_button_style = "MacOsNative"

-- config.font = wezterm.font("Liga SFMono Nerd Font")
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 16

-- tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
local current_window_icon = ""
local current_session_icon = ""
local username_icon = ""
local hostname_icon = "󰒋"
local date_time_icon = "󰃰"
local current_folder_icon = ""
local right_separator = "  "
local left_separator = "  "
local field_separator = " | "
local spacer = " "

wezterm.on("update-status", function(window, pane)
	local cells = {}

	-- table.insert(cells, { Background = { Color = config.colors.background } })
	table.insert(cells, { Foreground = { Color = config.colors.foreground } })
	table.insert(cells, { Text = spacer })
	table.insert(cells, { Text = current_session_icon })
	table.insert(cells, { Text = spacer })
	table.insert(cells, { Text = window:active_workspace() })
	table.insert(cells, { Foreground = { Color = config.colors.brights[1] } })
	table.insert(cells, { Text = field_separator })
	table.insert(cells, { Text = current_window_icon })
	table.insert(cells, { Text = spacer })
	table.insert(cells, { Foreground = { Color = config.colors.ansi[2] } })
	table.insert(cells, { Text = window:active_pane():get_title() })
	table.insert(cells, { Foreground = { Color = config.colors.brights[1] } })
	table.insert(cells, { Text = field_separator })
	table.insert(cells, { Foreground = { Color = config.colors.ansi[7] } })
	window:set_left_status(wezterm.format(cells))
end)

wezterm.on("update-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}
	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ""
		local hostname = ""

		cwd = cwd_uri.file_path
		hostname = cwd_uri.host or wezterm.hostname()

		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wezterm.hostname()
		end

		table.insert(cells, { Foreground = { Color = config.colors.ansi[3] } })
		local date = wezterm.strftime("%Y-%m-%d")
		local time = wezterm.strftime("%H:%M")
		table.insert(cells, { Text = time })
		table.insert(cells, { Foreground = { Color = config.colors.brights[1] } })
		table.insert(cells, { Text = field_separator })
		table.insert(cells, { Foreground = { Color = config.colors.ansi[3] } })
		table.insert(cells, { Text = date })
		table.insert(cells, { Foreground = { Color = config.colors.brights[1] } })
		table.insert(cells, { Text = right_separator .. date_time_icon })
		table.insert(cells, { Text = spacer })
		table.insert(cells, { Text = spacer })
		table.insert(cells, { Foreground = { Color = config.colors.foreground } })
		table.insert(cells, { Text = hostname })
		table.insert(cells, { Foreground = { Color = config.colors.brights[1] } })
		table.insert(cells, { Text = right_separator .. hostname_icon })
		table.insert(cells, { Text = spacer })
	end

	window:set_right_status(wezterm.format(cells))
end)

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "+", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "-", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "U", mods = "CTRL", action = act.DisableDefaultAssignment },
	-- splitting
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "|",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "z",
		action = act.TogglePaneZoomState,
	},

	-- rotate panes
	{
		mods = "LEADER",
		key = "Space",
		action = act.RotatePanes("Clockwise"),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		mods = "LEADER",
		key = "0",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

return config
