{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./torrent.nix ./wireguard.nix];

  networking.firewall.enable = true;
  networking.nftables.enable = true;

  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

  # systemd-resolved instead of dhcpcd
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  # networking.enableIPv6 = true; # TODO
  services.resolved = {
    enable = true;
    # dnssec = "true"; "opportunistic"
    dnssec = "false";
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    # extraConfig = ''
    #   DNSOverTLS=yes / allow-downgrade
    # '';
  };

  # Wired: systemd-networkd
  networking.useNetworkd = true;
  systemd.network.networks."40-wired" = {
    matchConfig = {Name = lib.mkForce "enp* eth*";};
    DHCP = "yes";
    networkConfig = {
      IPv6PrivacyExtensions = "yes";
    };
  };

  # TODO: Anonymize=yes ? Makes requests grow in size though

  # TODO: Not necessary since iwd handles it?
  # systemd.network.networks."40-wireless" = {
  #   matchConfig = { Name = lib.mkForce "wlp* wlan*"; };
  #   DHCP = "yes"
  # };

  # Wireless: iwd / iwctl
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = true;
      UseDefaultInterface = true;
    };
    Network = {
      NameResolvingService = "systemd";
    };
  };
}
