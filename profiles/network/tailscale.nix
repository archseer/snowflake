{lib, ...}: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--ssh"];
    # Using an exit node needs a loose reverse path filter
    useRoutingFeatures = lib.mkDefault "client";
    # Open the UDP port so peers can connect directly instead of through DERP
    openFirewall = true;
    disableUpstreamLogging = true;
  };
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
