{ pkgs, ... }: {
  # Override vim with neovim
  programs.neovim.enable = true;

  # environment.systemPackages = with pkgs; [
  #   cquery
  #   kak-lsp
  #   kakoune-config
  #   kakoune-unwrapped
  #   nixpkgs-fmt
  #   python3Packages.python-language-server
  #   rustup
  #   nix-linter
  #   dhall
  # ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # wrapper to specify config dir
  #     kakoune-config = prev.writeShellScriptBin "k" ''
  #       XDG_CONFIG_HOME=/etc/xdg exec ${final.kakoune}/bin/kak "$@"
  #     '';
  #   })
  # ];
}
