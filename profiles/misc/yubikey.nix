{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # yubico-piv-tool
    yubikey-personalization
  ];

  security.pam.u2f = {
    enable = true;

    # create key: `pamu2fcfg`
    authFile = pkgs.writeText "u2f_keys" ''
    speed:uKgq1fm0eveHC/3VssSUUnVQHoQ6MMaECcG/CqvIYpbUdFDHzN4b09EmLwZUyMRvzzJbeQdlaaXY3RxrSMDX+g==,hK9WQ468T5dj28mDYTLZG24SiZ0+YWrnGuGCAK+ulpzII1o3rjQnhBUUUOYX0OvSok3mDPbCIYkBROg3Bu6qqA==,es256,+presence
    speed:y4HD+Q/e7se6Mr4JYfdwmShRSI+gt1i6xlsj5hdZeQ/xGaokz1gYpYBU2Hv8ss4NozYaUuOyc74CLmKFo6N3Ew==,qn7t9XbnzBWfpg/k9ndqeVh/EnXmRWUa9wArv7yy6QaePoR9oKiNS9gLbOPVcj2xcfk5/peyD8xGsDsiayhc4A==,es256,+presence
    '';
  };
}
