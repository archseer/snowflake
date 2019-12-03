{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "209.97.160.1";
    defaultGateway6 = "2400:6180:0:d1::1";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="209.97.164.130"; prefixLength=20; }
{ address="10.15.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="2400:6180:0:d1::6ec:3001"; prefixLength=64; }
{ address="fe80::bcb5:3bff:feb5:d4db"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "209.97.160.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "2400:6180:0:d1::1"; prefixLength = 32; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="be:b5:3b:b5:d4:db", NAME="eth0"
    ATTR{address}=="5a:60:60:8a:90:f2", NAME="eth1"
  '';
}
