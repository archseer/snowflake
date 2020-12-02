# snowflake

Deterministic NixOS configuration for all my devices.

For a more detailed explanation of the code structure, check out the
[docs](./DOC.md).

# Setup

You'll need to have NixOS already installed since the `nixos-install` script
doesn't yet support flakes.

However you decide to acquire the repo, once you have it, you'll want to __move
or symlink__ it to `/etc/nixos` for ease of use. Once inside:

```
nix-shell # or `direnv allow` if you prefer
```

From here it's up to you. You can deploy the barebones [NixOS](./hosts/NixOS.nix)
host and build from there, or you can copy your existing `configuration.nix`.
You'll probably at least need to setup your `fileSystems` and make sure the
[locale](./local/locale.nix) is correct.

Once you're ready to deploy you can use `nixos-rebuild` if your NixOS version
is recent enough to support flakes, _or_ the [shell.nix](./shell.nix) defines
its own `rebuild` command in case you need it.

```
# Usage: rebuild host {switch|boot|test|iso}
rebuild <host-filename> test
```

## Build an ISO

You can make an ISO and customize it by modifying the [niximg](./hosts/niximg.nix)
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

[direnv]: https://direnv.net
[home-manager]: https://github.com/rycee/home-manager
[nixFlakes]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/package-management/nix/default.nix#L211
[NixOS]: https://nixos.org
[nixpkgs]: https://github.com/NixOS/nixpkgs
[nur]: https://github.com/nix-community/NUR
[wiki]: https://nixos.wiki/wiki/Flakes
