{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [piper];
  services.ratbagd.enable = true; # ratbagd + piper = logitech mouse config
}