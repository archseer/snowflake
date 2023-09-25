local wezterm = require 'wezterm';
return {
  enable_wayland = true,
  -- font_hinting = "None",
  --
  -- font = wezterm.font("Fira Code"),
  font = wezterm.font("ProggyCleanTT"),
  font_size = 14.0,
  line_height = 1.15,
  
  -- timeout_milliseconds defaults to 1000 and can be omitted
  leader = { key="a", mods="CTRL", timeout_milliseconds=1000 },
  keys = {
    {key="|", mods="LEADER|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="-", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {key="a", mods="LEADER|CTRL", action=wezterm.action{SendString="\x01"}},
  },
  
  window_frame = {
    -- The font used in the tab bar.
    -- Roboto Bold is the default; this font is bundled
    -- with wezterm.
    -- Whatever font is selected here, it will have the
    -- main font setting appended to it to pick up any
    -- fallback fonts you may have used there.
    font = wezterm.font({family="Inter"}),
    font_size = 11.0,

    active_titlebar_bg = "#281733",
  },

 -- color_scheme = "BirdsOfParadise",
  colors = {
    -- The default text color
    -- foreground = "#ebeafa",
    foreground = "#cccccc",
    -- The default background color
    background = "#3b224c",

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = "#c5c8c6",
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = "#1d1f21",
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- of the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = "#c5c8c6",

    -- the foreground color of selected text
    selection_fg = "#ffffff",
    -- the background color of selected text
    selection_bg = "#404040",

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#222222",

    -- The color of the split lines between panes
    split = "#444444",

    ansi = {"#3b224c", "#f47868", "#9ff28f", "#efba5d", "#a4a0e8", "#dbbfef", "#6acdca", "#ebeafa"},
    brights = {"#697c81", "#f47868", "#9ff28f", "#efba5d", "#a4a0e8", "#dbbfef", "#6acdca", "#ebeafa"},
    
    tab_bar = {
      active_tab =  {
        bg_color = "#3b224c",
        -- fg_color = "#ebeafa",
        fg_color = "#ffffff",
      },

      inactive_tab =  {
        bg_color = "#3b224c",
        fg_color = "#a4a0e8",
      },

      new_tab = {
        bg_color = "#5a5977",
        fg_color = "#ebeafa",
      },
    },
  }
}
