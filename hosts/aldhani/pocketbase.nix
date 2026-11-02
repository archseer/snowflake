{pkgs, ...}: {
  users.users.pocketbase = {
    isSystemUser = true;
    group = "pocketbase";
    home = "/var/lib/pocketbase";
  };
  users.groups.pocketbase = {};

  # For `sudo -u pocketbase pocketbase superuser upsert ...`
  environment.systemPackages = [pkgs.pocketbase];

  systemd.services.pocketbase = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http=127.0.0.1:8090 --dir=/var/lib/pocketbase/pb_data";
      WorkingDirectory = "/var/lib/pocketbase";
      User = "pocketbase";
      Group = "pocketbase";
      StateDirectory = "pocketbase";
      Restart = "on-failure";
      MemoryMax = "256M";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };

  services.caddy.virtualHosts."pb.mxxn.io".extraConfig = ''
    @public not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
    respond @public 404
    reverse_proxy 127.0.0.1:8090
  '';
}
