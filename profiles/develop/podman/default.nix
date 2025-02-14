{lib, pkgs, ...}: {
  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    # defaultNetwork.settings = lib.mkForce { };
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers.backend = "podman";

  virtualisation.containers.containersConf.settings.network.default_subnet_pools = [
    { "base" = "100.96.0.0/11"; "size" = 24; }
  ];

  # k3d seems broken on netavark
  # virtualisation.containers.containersConf.settings = {
  #   network.network_backend = lib.mkForce "cni";
  # };
  # virtualisation.containers.containersConf.cniPlugins = [ pkgs.dnsname-cni ];
  # environment.etc."cni/net.d/87-podman-bridge.conflist".text = builtins.toJSON {
  #   cniVersion = "0.4.0";
  #   name = "podman";
  #   plugins = [{
  #     type =  "bridge";
  #     bridge = "cni-podman0";
  #     isGateway = true;
  #     ipMasq = true;
  #     hairpinMode = true;
  #     ipam = {
  #       type = "host-local";
  #       routes = [{ dst = "0.0.0.0/0"; }];
  #       ranges = [
  #         [
  #           { subnet = "10.88.0.0/16"; gateway = "10.88.0.1"; }
  #         ]
  #       ];
  #     };
  #   }
  #   {
  #     type = "portmap";
  #     capabilities = {
  #       portMappings = true;
  #     };
  #   }
  #   {
  #     type = "firewall";
  #   }
  #   {
  #     type = "tuning";
  #   }];
  # };

  # environment.systemPackages = [ pkgs.docker-client ];
  # environment.systemPackages = [
  #   # daemonless docker
  #   buildah
  #   conmon
  #   podman
  #   runc
  #   shadow
  #   skopeo
  #   slirp4netns
  # ];
  environment.systemPackages = [pkgs.docker-compose];
  users.users.speed.extraGroups = ["podman"];
  # TODO: or virtualisation.containers.users instead?
}
