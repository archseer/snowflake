{
  config,
  lib,
  ...
}: 
{
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = ["--ssh" "--no-logs-no-support"];
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];

  # Don't log to log.tailscale.io
  systemd.services.tailscaled.serviceConfig.Environment = lib.mkAfter [
    "TS_NO_LOGS_NO_SUPPORT=true"
  ];
}
