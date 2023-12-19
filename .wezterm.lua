local wezterm = require("wezterm")
local config = {}

local mux = wezterm.mux
-- local act = wezterm.action

wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

return {
  -- font = wezterm.font('Berkeley Mono', { weight = 500 }),
  -- font = wezterm.font('CodeNewRoman Nerd Font', { weight = 500 }),
  -- font = wezterm.font('CaskaydiaCove Nerd Font', { weight = 500 }),
  -- font = wezterm.font("SFMono Nerd Font", { weight = 600 }),
  -- font = wezterm.font("Comic Code Ligatures", { weight = 600 }),
  -- font = wezterm.font("Maple Mono", { weight = 600 }),
  font = wezterm.font("Codelia Ligatures", { weight = 500 }),
  font_size = 14,
  line_height = 1.4,
  window_decorations = "RESIZE",
  color_scheme = "Hardcore",
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  },
  use_dead_keys = false,
  hide_tab_bar_if_only_one_tab = true,
  freetype_load_target = "Light",
  freetype_load_flags = "NO_HINTING",
  freetype_interpreter_version = 35,
  keys = {
    {
      key = "T",
      mods = "CTRL",
      action = wezterm.action.TogglePaneZoomState,
    },
  },
  unix_domains = {
    {
      name = "unix",
    },
  },
  -- default_gui_startup_args = {
  --   "connect",
  --   "unix",
  -- },
}
