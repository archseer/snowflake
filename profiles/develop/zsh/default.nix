{
  pkgs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  # completion.zsh runs compinit itself
  programs.zsh.enableGlobalCompInit = false;

  environment.systemPackages = with pkgs; [
    bat
    eza
    sd
    fd
    fzf
    skim
    procs

    # compression
    bzip2
    gzip
    lrzip
    p7zip
    # unrar
    unzip
    xz

    xdg-utils
  ];

  home-manager.sharedModules = [./home.nix];
}
