{
  pkgs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  # completion.zsh runs compinit itself
  programs.zsh.enableGlobalCompInit = false;

  environment.systemPackages =
    import ./packages.nix pkgs
    ++ (with pkgs; [
      # compression
      bzip2
      gzip
      lrzip
      p7zip
      # unrar
      unzip
      xz

      xdg-utils
    ]);

  home-manager.sharedModules = [./home.nix];
}
