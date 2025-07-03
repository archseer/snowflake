# snowflake

Deterministic NixOS configuration for all my devices.

# Setup

```
# Usage: rebuild host {switch|boot|test|iso}
rebuild <host-filename> test
```

```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#m4-macbook  
```

## Build an ISO

You can make an ISO and customize it by modifying the [iso](./hosts/iso.nix)
file:

```sh
rebuild iso
```

# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.
