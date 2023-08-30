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
  # tailscale up https://headscale.mxxn.io
  # headscale nodes register ... --user <namespace>
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8888;
      settings = {
        dns_config = {
          override_local_dns = true;
          nameservers = [ "1.1.1.1" ]; # TODO: and 100.100.100.100?
          base_domain = "mxxn.io";
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
