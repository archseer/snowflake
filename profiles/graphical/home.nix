{pkgs, ...}: {
  imports = [./misc/mpv/home.nix];

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.pop-gtk-theme;
    #   name = "Pop";
    # };
    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
    # TODO: gtk-cursor-theme-name..
  };

  # Wayland support in electron-based apps
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
}
