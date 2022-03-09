# NixOS Config

_Heavily inspired by a config I found [here](https://github.com/barsoosayque/nixconfig/)_

A home for my ever-evolving NixOS configuration.

# Usage

## Update
```sh
nix flake update
```

**OR**

Manually by specifying commit hash(es) in `flake.nix#inputs`.

## Apply
```sh
# FIXME: currently requires `--impure` due to VSCode extensions
nixos-rebuild switch --flake .#$(hostname) --impure
```

## Install
> TODO: