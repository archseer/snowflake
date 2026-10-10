{
  config,
  ...
}: 
{
  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--ssh"];
  # Don't log to log.tailscale.io
  services.tailscale.disableUpstreamLogging = true;
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];

  # systemd.services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
}
