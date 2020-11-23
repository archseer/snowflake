{ lib, pkgs, ... }:
let
  inherit (builtins) readFile concatStringsSep;
  # inherit (lib) removePrefix;

  # pluginConf = plugins:
  #   concatStringsSep "\n\n" (map
  #     (plugin:
  #       let name = removePrefix "tmuxplugin-" plugin.pname;
  #       in "run-shell ${plugin}/share/tmux-plugins/${name}/${name}.tmux")
  #     plugins
  #   );

  # plugins = with pkgs.tmuxPlugins; [
  #   open
  #   yank
  #   vim-tmux-navigator
  # ];
in
{
  # environment.shellAliases = { tx = "tmux new-session -A -s $USER"; };

  programs.tmux = {
    enable = true;
    # sensible defaults
    sensibleOnTop = true;

    # set by tmux-sensible
    # escapeTime = 0;
    # historyLimit = 10000;
    # terminal = "tmux-256color";
    # aggressiveResize = true;
    # focus-events

    # TODO: doesn't work because it tries binding C-`
    # shortcut = "`";

    # start window and pane numbers at 1
    baseIndex = 1;

    clock24 = true;

    customPaneNavigationAndResize = false; # use own mappings
    disableConfirmationPrompt = true;

    # Use vi style keys
    keyMode = "vi";

    extraConfig = ''
      ${readFile ./tmux.conf}
    '';
    # ${pluginConf plugins}
  };
}
