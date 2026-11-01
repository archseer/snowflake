{
  config,
  pkgs,
  ...
}: 
let
  domain = "headscale.mxxn.io";
  derpPort = 3478;
  user = "space@";
  policy = {
    acls = [
      {
        action = "accept";
        src = [user];
        dst = ["*:*"];
      }
    ];
    ssh = [
      {
        action = "accept";
        src = [user];
        dst = [user];
        users = ["speed"];
      }
    ];
    autoApprovers.exitNode = [user];
  };
in {
  # headscale users create space
  # headscale preauthkeys create --user <id from `headscale users list`> --expiration 1h
  # tailscale up --login-server https://headscale.mxxn.io --auth-key <key>
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
        policy.path = pkgs.writeText "policy.hujson" (builtins.toJSON policy);
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
