{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tdesktop # telegram
    slack
  ];
}
