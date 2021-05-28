{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    transmission
    transmission-gtk
  ];
}
