{ config, pkgs, ... }:

{
  config = {
    home-manager.users.speed = { pkgs, ... }: {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        # TODO: how can I inherit `system` here?
        plugins = with pkgs.vimPlugins; [
          # Themes
          # TODO: colibri.vim

          auto-pairs # TODO: needs to load before rust-vim

          # Languages
          vim-elixir
          vim-nix
          rust-vim
          vim-polyglot

          # neovim 0.5
          nvim-lspconfig
          completion-nvim        
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
          vim-highlightedyank
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
    };
  };
}
