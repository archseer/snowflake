{ pkgs, config, inputs, ... }:

{
  programs.jujutsu = {
    enable = true;
    package = inputs.jj.outputs.packages.${pkgs.stdenv.hostPlatform.system}.jujutsu;
    settings = {
      user = {
        name = "Blaž Hrastnik";
        email = "blaz@mxxn.io";
      };
      ui = {
        color = "always";
        pager = "delta";
      };
      diff = {
        format = "git";
      };
    };
  };
}