{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-repeat
      vim-abolish

      fzf-vim
      fzfWrapper
    ];

    extraConfig = builtins.readFile ./init.vim;
  };
}
