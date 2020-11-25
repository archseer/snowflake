{ lib, ... }: {
  networking.dhcpcd.enable = false;
  # use iwd + connman
  networking.wireless.iwd.enable = true;
  # stop renaming predictable names to wlan0
  # environment.etc."iwd/main.conf".text = ''
  # [General]
  # UseDefaultNetworkInterface=true
  # '';
  services.connman = {
    enable = true;
    wifi.backend = "iwd";
    # nm used dns force none /systemd-resolved=false
  };

  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  #   extraConfig = ''
  #     DNSOverTLS=yes
  #   '';
  # };
}
