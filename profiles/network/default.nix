{
  lib,
  ...
}: {
  imports = [./torrent.nix ./wireguard.nix];

  networking.firewall.enable = true;
  networking.nftables.enable = true;

  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

  # systemd-resolved instead of dhcpcd
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = false;
      Domains = [ "~." ];
      # Use TLS where port 853 is reachable
      DNSOverTLS = "opportunistic";
      LLMNR = false;
    };
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

  # Wireless: iwd / iwctl
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = true;
    };
    Network = {
      NameResolvingService = "systemd";
    };
  };
}
