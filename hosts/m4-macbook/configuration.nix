{pkgs, ...}:

{
  system.stateVersion = 5;
  users.users.blazhrastnik = {
    home = "/Users/blazhrastnik";
    shell = pkgs.zsh;
  };
  # Use Determinate's nix
  nix.enable = false;
  nix.settings.trusted-users = ["root" "blazhrastnik"];
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
