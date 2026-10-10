{
  config,
  pkgs,
  ...
}: 
let
  domain = "headscale.mxxn.io";
  derpPort = 3478;
in {
  # headscale namespaces create <namespace>
  # tailscale up https://headscale.mxxn.io --ssh
  # headscale nodes register ... --user <namespace>
  services = {
    headscale = {
      enable = true;
      # Only reached through caddy
      address = "127.0.0.1";
      port = 8888;
      settings = {
        dns = {
          override_local_dns = true;
          nameservers.global = [ "1.1.1.1" ];
          base_domain = "tailnet.mxxn.io";
        };
        server_url = "https://${domain}";
        logtail.enabled = false;
        # log.level = "warn";
        # ip_prefixes
        derp.server = {
          enable = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:${toString derpPort}";
        };
      };
    };

    caddy.virtualHosts.${domain}.extraConfig = ''
    reverse_proxy http://localhost:${toString config.services.headscale.port}
    '';
  };

  networking.firewall.allowedUDPPorts = [derpPort];

  environment.systemPackages = [ config.services.headscale.package ];
}
