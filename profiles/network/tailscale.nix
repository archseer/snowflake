{
  config,
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
}
