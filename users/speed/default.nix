{ lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Blaž Hrastnik";
in
{

  imports = [ ../../profiles/develop  ];

  users.users.speed.packages = with pkgs; [
    v4l-utils
  ];

  environment.systemPackages = with pkgs; [ cachix ];

  home-manager.users.speed = {
    imports = [
      ../profiles/git
      ../profiles/alacritty
      ../profiles/direnv
    ];

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };

    # required so home doesn't import <nixpkgs>
    home.stateVersion = "20.09";

    programs.git = {
      userName = name;
      userEmail = "blaz@mxxn.io";
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

  users.users.speed = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    # mkpasswd -m sha-512 <password>
    hashedPassword = "$6$KlMOHNWhChBEqYE$N8oRMBlpnCSl/r4fzqyhWaFCAWs.IhM7q9bjAw5ZT.aDDEE8X5p0vO06cYoHEp/whyneKXsan9QmD6RZSJXl0.";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhYkvu/rVDYYlcM8Rq8HP3KPY2AX3mCvmyZ+/L1/yuh speed@hyrule.local"];
    # shell = pkgs.zsh;
    # video is needed to control the backlight
    extraGroups = [ "wheel" "input" "docker" "video"]; # audio ?
  };
}
