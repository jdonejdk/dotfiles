local wezterm = require 'wezterm'

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local str = tab.active_pane.title
    local index = tab.tab_index + 1
    if str == "vim" then
      str = "nvim"
    else
      str = string.gsub(str, '(.*[/\\])(.*)', '%2')
    end

    local title = ' ' .. index .. ':' .. str .. ' '

    if tab.is_active then
      return { { Background = { Color = 'green' } }, { Text = title } }
    end

    return { { Text = title } }
  end
)


local key_bindings = {
  { key = 'Enter', mods = 'CMD', action = wezterm.action.ToggleFullScreen },
  { key = 'c', mods = 'CMD', action = wezterm.action.Copy },
  { key = 'v', mods = 'CMD', action = wezterm.action.Paste },
  { key = 'h', mods = 'CMD', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'CMD', action = wezterm.action.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'CMD', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'CMD', action = wezterm.action.ActivatePaneDirection('Right') },
  { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = 'd', mods = 'CMD', action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 50 } } },
  { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 50 } } },
  { key = 'n', mods = 'CMD', action = wezterm.action.RotatePanes 'Clockwise' }
}

local mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.Paste,
  },
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'PrimarySelection',
  },
  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- https://wezfurlong.org/wezterm/config/lua/config/hyperlink_rules.html#hyperlink_rules
local hyperlink_rules = {
  { regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b', format = '$0' },
  -- { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = 'mailto:$0' },
  -- { regex = [[\bfile://\S*\b]], format = '$0' },
  -- { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = '$0' },
  -- { regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = 'https://www.github.com/$1/$3' },
  -- match the URL with a PORT
  { regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b", format = "$0", },
}



return {
  automatically_reload_config                = true,
  use_ime                                    = true,
  scrollback_lines                           = 5000,
  check_for_updates                          = false,
  window_decorations                         = "NONE | RESIZE",
  -- disable_default_mouse_bindings             = true,
  audible_bell                               = 'Disabled',
  prefer_egl                                 = true,
  native_macos_fullscreen_mode               = true,
  enable_tab_bar                             = true,
  use_fancy_tab_bar                          = false,
  tab_bar_at_bottom                          = false,
  show_tab_index_in_tab_bar                  = true,
  adjust_window_size_when_changing_font_size = false,
  default_cursor_style                       = 'SteadyBlock',
  force_reverse_video_cursor                 = false,
  use_cap_height_to_scale_fallback_fonts     = true,
  font                                       = wezterm.font_with_fallback {
    -- { family = 'Monaco', weight = 'Regular', harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, scale = 1.0, dpi = 192 },
    { family = 'FiraCode Nerd Font', weight = 'Regular', scale = 1.0, dpi = 192 },
    -- { family = '苹方-简', weight = 'Regular', scale = 1.0, dpi = 192 },
  },
  font_rules                                 = {
    -- NOTE: i prefer disable italic & bold.
    -- { intensity = "Bold", font = wezterm.font('Monaco', { weight = 'Regular' }) },
    { italic = true, font = wezterm.font('VictorMono Nerd Font', { weight = 'Regular' }) },
  },
  font_size                                  = 16,
  bold_brightens_ansi_colors                 = false,
  freetype_load_target                       = 'Normal',
  freetype_load_flags                        = 'NO_HINTING|MONOCHROME',
  -- color_scheme                               = 'Gruvbox dark, hard (base16)',
  -- color_scheme                               = 'arcoiris',
  color_scheme                               = 'Ayu Mirage',
  -- color_scheme                               = 'Dracula+',
  tab_max_width                              = 35,
  initial_rows                               = 35,
  initial_cols                               = 120,
  window_background_opacity                  = 1,
  text_background_opacity                    = 1,
  window_padding                             = { left = 5, right = 5, top = 5, bottom = 5 },
  -- inactive_pane_hsb                          = { brightness = 0.8, hse = 0.5, saturation = 0.8 },
  keys                                       = key_bindings,
  mouse_bindings                             = mouse_bindings,
  hyperlink_rules                            = hyperlink_rules,
  window_background_image_hsb = {
    brightness = 0.3,
    hue = 1.0,
    saturation = 1.0,
  },
}
