{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kak-lsp
    kakoune-config
    kakoune-unwrapped
  ];

  environment.etc = {
    "xdg/kak/kakrc".source = ./kakrc;
    "xdg/kak/autoload/plugins".source = ./plugins;
    "xdg/kak/autoload/lint".source = ./lint;
    "xdg/kak/autoload/lsp".source = ./lsp;
    "xdg/kak/autoload/default".source =
      "${pkgs.kakoune-unwrapped}/share/kak/rc";
  };

  nixpkgs.overlays = [
    (final: prev: {
      # wrapper to specify config dir
      kakoune-config = prev.writeShellScriptBin "k" ''
        XDG_CONFIG_HOME=/etc/xdg exec ${final.kakoune}/bin/kak "$@"
      '';
    })
  ];
}
