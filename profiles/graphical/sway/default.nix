{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    capitaine-cursors
  ];

  # Apparently required for GTK3 settings on sway
  programs.dconf.enable = true;

  xdg.portal.config.common.default = "*"; 
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  home-manager.sharedModules = [./home.nix];
}
