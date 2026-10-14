{osConfig, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = osConfig.my.user.fullName;
        inherit (osConfig.my.user) email;
      };
      ui = {
        color = "always";
        pager = "delta";
        diff-formatter = ":git";
      };
    };
  };
}
