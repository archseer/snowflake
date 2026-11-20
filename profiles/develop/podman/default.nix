{pkgs, ...}: {
  # Containers run rootless
  virtualisation.podman = {
    enable = true;
    # `docker` runs podman
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # docker-compose and other Docker clients talk to the rootless podman socket
  environment.variables.DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
  environment.systemPackages = [pkgs.docker-compose];
}
