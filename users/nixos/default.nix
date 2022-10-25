{
  imports = [../../profiles/develop];

  home-manager.users.nixos = {
    imports = [../profiles/git ../profiles/direnv];

    # required so home doesn't import <nixpkgs>
    home.stateVersion = "20.09";
  };

  users.users.nixos = {
    uid = 1000;
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
