{ lib, ... }: {
  networking.wireless.iwd.enable = true;
  services.connman = {
    enable = true;
    connman.wifi.backend = "iwd";
    # nm used dns force none /systemd-resolved=false
  };

  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  networking.wireless.iwd.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
