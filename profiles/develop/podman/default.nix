{ pkgs, ... }:
{
  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.dnsname.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";

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
  environment.systemPackages = [ pkgs.docker-compose ];
  users.users.speed.extraGroups = ["podman"];
  # TODO: or virtualisation.containers.users instead?
}
