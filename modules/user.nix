{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.my.user = {
    name = mkOption {
      type = types.str;
      description = "Login";
    };
    fullName = mkOption {type = types.str;};
    email = mkOption {type = types.str;};
    sshKeys = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    signingKey = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
}
