{ config, lib, pkgs, ... }:
{
  # Deployed from a private flake so avoid system upgrades reverting it
  system.autoUpgrade.enable = lib.mkForce false;
  nix.settings.trusted-users = [ "speed" ];

  services.haven = {
    enable = true;
    adminKeys = config.my.user.sshKeys;

    sshListen = "0.0.0.0:2222";
    remote = "ssh://haven@aldhani:2222";

    webHost = "haven.mxxn.io";
    webAccess = "private"; # every page needs a passkey session
    pushSubject = "mailto:haven@mxxn.io"; # Web Push services' contact

    # Sites haven may create: <name>.mxxn.io.
    domains = [ "mxxn.io" ];

    addresses = {
      # The first tailnet address is where `haven doctor` asks Caddy for each site.
      tailnet = [ "100.64.0.1" "fd7a:115c:a1e0::1" ];
      # Builds can't reach these, nor the tailnet.
      public = [ "209.97.164.130" "2400:6180:0:d1::6ec:3001" ];
    };

    # Deploy hooks, if any. A hook's name is [a-z0-9-] (no dots: a dot means a site's host).
    # Example:
    # hooks.api = { script = ./deploy-api.sh; user = "api"; repos = [ "api" ]; };
  };

  # haven-web, tailnet only, on haven.mxxn.io.
  services.headscale.settings.dns.extra_records = [
    { name = "haven.mxxn.io"; type = "A";    value = "100.64.0.1"; }
    { name = "haven.mxxn.io"; type = "AAAA"; value = "fd7a:115c:a1e0::1"; }
  ];
  services.caddy.virtualHosts."haven.mxxn.io".extraConfig = ''
    # needs to be nested in a route, or Caddy ends up in the catch-all handle and serves it publicly
    @outside not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
    route {
      respond @outside 404
      encode zstd gzip
      handle /api/* {
        reverse_proxy unix//run/haven/api/api.sock
      }
      handle {
        reverse_proxy unix//run/haven-web/web.sock
      }
    }
  '';
}
