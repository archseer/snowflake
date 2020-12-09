{ config, lib, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;
}
