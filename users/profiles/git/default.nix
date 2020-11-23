{
  programs.git = {
    enable = true;

    delta = true;

    extraConfig = {
      core = {
        whitespace = "space-before-tab, trailing-space";
        # excludesfile = "" XDG .gitignore
        # pager = diff-so-fancy | less --tabs=4 -RFX
      };
      diff = {
        # enames = "copies";
        mnemonicprefix = true;
      };
      push = {
        default = "simple";
      };
      merge = {
        conflictstyle = "diff3";
      };
      rerere = {
        enabled = 1;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
      # TODO: color config
      diff-so-fancy = {
        stripLeadingSymbols = false;
        markEmptyLines = false;
      };
    };

    aliases = {
	a	= "add";
	ap	= "add --patch";
	b	= "branch";
	bd	= "branch -d";
	bdd     = "branch -D";
	c	= "commit -v";
	ca	= "commit -v --amend";
	co	= "checkout";
	cp	= "cherry-pick";
	d	= "diff";
	dc	= "diff --cached";
	ds	= "diff --staged";
	f	= "fetch";
	fx	= "commit --fixup";
	g	= "grep -n";
	hrd     = "reset --hard";
	l	= "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(yellow)%an%Creset' --all --abbrev-commit --date=relative";
	ls	= "log --stat --oneline # show log with filediffs only";
	m	= "merge";
	mm	= "merge origin/master";
	p	= "push";
	pf	= "push --force-with-lease";
	pl	= "pull --rebase";
#	pm	= "push origin master;
#	pms = push origin master:staging;
#	pmp = push origin master:production;
	r	= "rebase";
	ra	= "rebase --abort";
	rc	= "rebase --continue";
	ri	= "rebase --interactive --autosquash";
	rom     = "rebase origin/master";
	rs	= "rebase --skip";
	s	= "status";
	sh	= "!git-sh";
	sq	= "commit --squash";
	st	= "diff-tree --no-commit-id --name-only -r # show file tree of commit";
	sw	= "show";
	w	= "whatchanged";

	undo = "reset --soft HEAD^";
	standup = "shortlog --since='1 week ago'";
	who = "shortlog -s -n --no-merges";
    };
  };

}
