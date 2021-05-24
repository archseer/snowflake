{ pkgs, ... }:

{
    # install colibri
    # xdg.configFile."nvim/colors/colibri.vim".source = "${colibri-vim}/colors/colibri.vim";

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      viAlias = true;
      vimAlias = true;

      # could use configure = { start = [], opt = [] }
      
      # TODO: how can I inherit `system` here?
      plugins = with pkgs.vimPlugins; [
        # Themes
        pkgs.colibri-vim

        auto-pairs # TODO: needs to load before rust-vim

        # Languages
        vim-elixir
        vim-nix
        rust-vim
        vim-go
        # vim-polyglot

        # neovim 0.5
        nvim-lspconfig
        # completion-nvim        
        nvim-compe
        # TODO: completion-buffers
        # nvim-treesitter        # neovim 0.5
        # completion-treesitter  # neovim 0.5
        #lsp-status-nvim        # neovim 0.5
        diagnostic-nvim # TODO: deprecated

        # Code manipulation
        splitjoin-vim
        vim-easy-align

        vim-repeat
        vim-abolish
        vim-commentary
        # -endwise
        vim-unimpaired
        vim-peekaboo

        # tentative:
        vim-sandwich
        vim-matchup
        emmet-vim
        vim-test
        # aerojump-nvim

        vim-dirvish
        fzf-vim
        fzfWrapper
      ];

      extraConfig = builtins.readFile ./init.vim;
    };
}
