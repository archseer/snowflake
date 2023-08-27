{
  lib,
  nixpkgs,
  inputs,
  ...
}:
(mobile-nixos.mkDevice {
  device = "pine64-pinephone";
  configuration = [
    {
      imports = [
        (import "${inputs.mobile-nixos}/lib/configuration.nix" {
          device = "pine64-pinephone";
        })
      ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.05"; # Did you read the comment?
    }
  ];
  pkgs = import nixpkgs {
    system = "x86_64-linux";
  };
})
.config
