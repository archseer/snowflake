{
  pkgs,
  ...
}: let
  name = "Blaž Hrastnik";
  email = "blaz@mxxn.io";
  username = "speed";
in {
  environment.systemPackages = with pkgs; [cachix];

  programs.gnupg.agent.pinentry.package = pkgs.pinentry-curses;

  home-manager.users.speed = {
    imports = [
      ../profiles/git
      ../profiles/jj
      ../profiles/direnv
    ];

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses; 
    };

    home.stateVersion = "23.05";

    programs.git = {
      userName = name;
      userEmail = email;
      signing = {
        key = "F604E0EBDF3A34F2B9B472621238B9C4AD889640";
        #   signByDefault = true;
      };
      # TODO: sendemail config
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      # matchBlocks =
      #   let
      #     githubKey = toFile "github" (readFile ../../secrets/github);

      #     # gitlabKey = toFile "gitlab" (readFile ../../secrets/gitlab);
      #   in
      #   {
      #     github = {
      #       host = "github.com";
      #       identityFile = githubKey;
      #       extraOptions = { AddKeysToAgent = "yes"; };
      #     };
      #     # gitlab = {
      #     #   host = "gitlab.com";
      #     #   identityFile = gitlabKey;
      #     #   extraOptions = { AddKeysToAgent = "yes"; };
      #     # };
      #   };
    };
  };

  # Avoid typing the username on TTY and only prompt for the password
  # https://wiki.archlinux.org/title/Getty#Prompt_only_the_password_for_a_default_user_in_virtual_console_login
  services.getty.loginOptions = "-p -- ${username}";
  services.getty.extraArgs = [ "--noclear" "--skip-login" ];

  users.users.speed = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    # mkpasswd -m sha-512 <password>
    hashedPassword = "$6$KlMOHNWhChBEqYE$N8oRMBlpnCSl/r4fzqyhWaFCAWs.IhM7q9bjAw5ZT.aDDEE8X5p0vO06cYoHEp/whyneKXsan9QmD6RZSJXl0.";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhYkvu/rVDYYlcM8Rq8HP3KPY2AX3mCvmyZ+/L1/yuh speed@hyrule.local"];
    # shell = pkgs.zsh;
    # video is needed to control the backlight
    extraGroups = ["wheel" "input" "docker" "video"];
  };
}
