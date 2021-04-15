{ config, lib, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      autoload
    ];
  };

  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;
}
