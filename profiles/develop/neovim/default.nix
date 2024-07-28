{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-repeat vim-abolish ];
    extraConfig = builtins.readFile ./init.vim;
  };
}
