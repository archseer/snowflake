{
  config,
  pkgs,
  ...
}: let
  cfg = config.my.user;
in {
  my.user.name = "speed";

  environment.systemPackages = with pkgs; [cachix];

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;

  home-manager.users.${cfg.name} = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
    };

    home.stateVersion = "23.05";

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          hashKnownHosts = true;
        };
      };

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
  services.getty.loginOptions = "-p -- ${cfg.name}";
  services.getty.extraArgs = [ "--noclear" "--skip-login" ];

  users.users.${cfg.name} = {
    uid = 1000;
    description = cfg.fullName;
    isNormalUser = true;
    # mkpasswd -m sha-512 <password>
    hashedPassword = "$6$KlMOHNWhChBEqYE$N8oRMBlpnCSl/r4fzqyhWaFCAWs.IhM7q9bjAw5ZT.aDDEE8X5p0vO06cYoHEp/whyneKXsan9QmD6RZSJXl0.";
    openssh.authorizedKeys.keys = cfg.sshKeys;
    # shell = pkgs.zsh;
    # video is needed to control the backlight
    extraGroups = ["wheel" "input" "docker" "video"];
  };
}
