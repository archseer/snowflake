{pkgs, ...}: {
  hardware.ledger.enable = true;

  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [ledger-live-desktop];
    })
  ];
}
