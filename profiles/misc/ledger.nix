{ pkgs, ... }:
{
  hardware.ledger.enable = true;

  home-manager.users.speed = { pkgs, ... }: {
    home.packages = with pkgs; [ ledger-live-desktop ];
  };
}
