{
  imports = [ ./adblocking.nix ];
  # ./stubby ./torrent
  
  networking.firewall.enable = true;

  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  # systemd-resolved instead of dhcpcd
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  # networking.enableIPv6 = true; # TODO
  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  # Wireless: iwd / iwctl
  networking.wireless.iwd.enable = true;
  environment.etc."iwd/main.conf".text = ''
  [General]
  EnableNetworkConfiguration=true
  UseDefaultNetworkInterface=true # stop renaming predictable names to wlan0
  [Network]
  NameResolvingService=systemd
  #RoutePriorityOffset
  '';

}
