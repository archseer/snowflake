{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.decorations = "full";
      font.normal.family = "ProggyCleanTT";
      font.bold.family = "ProggyCleanTT";
      font.bold.style = "Bold";
      font.italic.family = "ProggyCleanTT";
      font.size = 14.0;
      font.offset = { x = 0; y = 4; };

      # snazzy theme
      colors = {
        # Default colors
        primary = {
          text = "0xebeafa";
          background= "0x3b224c";
          dim_foreground = "0x9a9a9a";
          bright_foreground = "0xffffff";
        };

        selection = {
          text = "#eaeaea";
          background = "#404040";
        };

        # Normal colors
        normal = {
          black =   "#3b224c";
          red =     "#f47868";
          green =   "#9ff28f";
          yellow =  "#efba5d";
          blue =    "#a4a0e8";
          magenta = "#dbbfef";
          cyan =    "#6acdca";
          white =   "#ebeafa";
        };

        # Bright colors
        bright = {
          black =  "#697c81";
          red =    "#ff3334";
          green =  "#9ec400";
          yellow = "#e7c547";
          blue =   "#7aa6da";
          magenta = "#b77ee0";
          cyan =   "#54ced6";
          white =  "#ffffff";
        };
      };
    };
  };
}
