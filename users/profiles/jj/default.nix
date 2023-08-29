{ pkgs, config, inputs, ... }:

{
  programs.jujutsu = {
    enable = true;
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