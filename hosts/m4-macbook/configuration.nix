{config, pkgs, ...}:

{
  system.stateVersion = 5;
  # completion.zsh runs compinit itself
  programs.zsh.enableGlobalCompInit = false;
  my.user.name = "blazhrastnik";
  users.users.${config.my.user.name} = {
    home = "/Users/${config.my.user.name}";
    shell = pkgs.zsh;
  };
  home-manager.users.${config.my.user.name} = import ./home.nix;
  # Use Determinate's nix
  nix.enable = false;
  nix.settings.trusted-users = ["root" config.my.user.name];
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
