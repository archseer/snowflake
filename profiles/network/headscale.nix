{
  config,
  pkgs,
  ...
}: 
let
  domain = "headscale.mxxn.io";
  derpPort = 3478;
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8888;
      settings = {
        dns_config = { base_domain = "mxxn.io"; };
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
    reverse_proxy http://localhost:${toString config.services.headscale.port}"
    '';
  };

  networking.firewall.allowedUDPPorts = [derpPort];

  environment.systemPackages = [ config.services.headscale.package ];
}
