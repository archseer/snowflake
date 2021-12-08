{ pkgs, ... }:

{
    # install colibri
    # xdg.configFile."nvim/colors/colibri.vim".source = "${colibri-vim}/colors/colibri.vim";

    programs.neovim = {
      enable = true;
      # could use configure = { start = [], opt = [] }
      
      # TODO: how can I inherit `system` here?
      plugins = with pkgs.vimPlugins; [
        # Themes
        pkgs.colibri-vim

        auto-pairs # TODO: needs to load before rust-vim

        # Languages
        vim-nix
        rust-vim
        vim-go

        # Code manipulation
        splitjoin-vim

        vim-repeat
        vim-abolish
        vim-commentary
        vim-unimpaired
        vim-peekaboo

        # tentative:
        vim-matchup

        vim-dirvish
        fzf-vim
        fzfWrapper
      ];

      extraConfig = builtins.readFile ./init.vim;
    };
}
