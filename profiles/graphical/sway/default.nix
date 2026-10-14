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

  xdg.portal.config.common = {
    default = ["gtk"];
    "org.freedesktop.impl.portal.ScreenCast" = "wlr";
    "org.freedesktop.impl.portal.Screenshot" = "wlr";
    # wlr does not have this interface
    "org.freedesktop.impl.portal.Inhibit" = "none";
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  home-manager.sharedModules = [./home.nix];
}
