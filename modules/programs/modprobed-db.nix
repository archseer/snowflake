{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.modprobed-db;
in
{
  ###### interface

  options = {

    services.modprobed-db = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable modprobed-db
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.modprobed-db ];
  };

}
