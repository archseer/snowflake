{
  pkgs,
  ...
}: {
  # programs.gh = {
  #   enable = true;
  #   enableGitCredentialHelper = true;
  #   settings.git_protocol = "ssh";
  # };

  # Additional git packages
  home.packages = with pkgs.gitAndTools; [ git-absorb git-revise ];
  
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        overrideGpg = true;
      };
    };
  };

  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options = {
        navigate = true;
        syntax-theme = "OneHalfDark";
        features = "side-by-side line-numbers decorations"; # hyperlinks
        whitespace-error-style = "22 reverse";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
    };

    extraConfig = {
      core = {
        whitespace = "space-before-tab, trailing-space";
        # excludesfile = "" XDG .gitignore
        # pager = diff-so-fancy | less --tabs=4 -RFX
      };
      credential = {
        helper = "cache --timeout=3600";
      };
      commit = {
        # Show my changes when writing the message
        verbose = true;
      };
      diff = {
        algorithm = "histogram";
        renames = "copies";
        mnemonicprefix = true;
        colormoved = "default";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      rerere = {
        enabled = 1;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
        updateRefs = true;
      };
      transfer = {
        credentialsInUrl = "warn";
      };
      absorb = {
        maxstack = 50;
      };
      # TODO: color config
      # diff-so-fancy = {
      #   stripLeadingSymbols = false;
      #   markEmptyLines = false;
      # };
    };

    aliases = {
      a = "add";
      ap = "add --patch";
      b = "branch -vv";
      bd = "branch -d";
      bdd = "branch -D";
      c = "commit";
      ca = "commit --amend";
      co = "checkout";
      cp = "cherry-pick";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      f = "fetch";
      fx = "commit --fixup";
      g = "grep -n";
      hrd = "reset --hard";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(yellow)%an%Creset' --all --abbrev-commit --date=relative";
      ls = "log --stat --oneline"; # show log with filediffs only
      m = "merge";
      mm = "merge origin/master";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull --rebase";
      r = "rebase";
      ra = "rebase --abort";
      rc = "rebase --continue";
      ri = "rebase --interactive --autosquash";
      rom = "rebase origin/master";
      rs = "rebase --skip";
      s = "status";
      sh = "!git-sh";
      sq = "commit --squash";
      st = "diff-tree --no-commit-id --name-only -r"; # show file tree of commit
      sw = "show";
      w = "whatchanged";

      undo = "reset --soft HEAD^";
      standup = "shortlog --since='1 week ago'";
      who = "shortlog -s -n --no-merges";
    };
  };
}
