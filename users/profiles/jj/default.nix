{ ... }:

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
        diff = {
          format = "git";
        };
      };
      git = {
        # Helps with yubikey issues https://github.com/jj-vcs/jj/pull/5228
        subprocess = true;
      };
    };
  };
}
