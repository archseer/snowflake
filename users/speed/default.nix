{ lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Blaž Hrastnik";
in
{

  imports = [ ../../profiles/develop  ];

  users.users.root.hashedPassword = lib.mkForce "$6$F5AAi9NA8wWXXW$eY/MXfj2bkPDdxJRaNvCdadmol0zW5E2VrWdnatgnHEakDqPfJ/Mt61iOznD.rsO8hGde01zU2113xgVfk3F2/";

  # users.users.speed.packages = with pkgs; [ pandoc ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [ cachix ];

  # TODO: move to core
  home-manager.useGlobalPkgs = true; # is this equivalent to stateVersion 20.09?
  home-manager.useUserPackages = true;

  home-manager.users.speed = {
    # imports = [ ../profiles/git ../profiles/alacritty ../profiles/direnv ];

    home = {
      # required so home doesn't import <nixpkgs>
      stateVersion = "20.09";


      # packages = mkForce [ ];

      # file = {
      # };
    };

    # programs.mpv = {
    #   enable = true;
    #   config = {
    #     ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
    #     hwdec = "auto";
    #     vo = "gpu";
    #   };
    # };

    # programs.mako.enable = true;

    programs.git = {
      userName = name;
      userEmail = "blaz@mxxn.io";
      # signing = {
      #   key = "TODO";
      #   signByDefault = true;
      # };
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
    extraGroups = [ "wheel" "input" "docker" ]; # audio ?
  };
}
