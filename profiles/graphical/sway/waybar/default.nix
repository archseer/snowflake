{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = pkgs.lib.readFile ./style.css;
    # TODO: settings
    xdg.configFile."waybar/config".text = pkgs.lib.readFile ./config;
  };
}
