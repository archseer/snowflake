{ lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Blaž Hrastnik";
in
{

  imports = [ ../../profiles/develop  ];

  users.users.root.hashedPassword = fileContents ../../secrets/root;

  users.users.speed.packages = with pkgs; [ pandoc ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [ cachix ];

  home-manager.users.speed = {
    imports = [ ../profiles/git ../profiles/alacritty ../profiles/direnv ];

    home = {
      packages = mkForce [ ];

      file = {
      };
    };

    programs.mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        hwdec = "auto";
        vo = "gpu";
      };
    };

    programs.git = {
      userName = name;
      userEmail = "blaz@mxxn.io";
      signing = {
        key = "TODO";
        signByDefault = true;
      };
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks =
        let
          githubKey = toFile "github" (readFile ../../secrets/github);

          # gitlabKey = toFile "gitlab" (readFile ../../secrets/gitlab);
        in
        {
          github = {
            host = "github.com";
            identityFile = githubKey;
            extraOptions = { AddKeysToAgent = "yes"; };
          };
          # gitlab = {
          #   host = "gitlab.com";
          #   identityFile = gitlabKey;
          #   extraOptions = { AddKeysToAgent = "yes"; };
          # };
        };
    };
  };

  users.groups.media.members = [ "speed" ];

  users.users.speed = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    hashedPassword = fileContents ../../secrets/speed;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhYkvu/rVDYYlcM8Rq8HP3KPY2AX3mCvmyZ+/L1/yuh speed@hyrule.local"];
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "docker" "libvirtd" ];
  };
}
