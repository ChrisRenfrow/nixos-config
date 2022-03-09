input@{ nixpkgs, pkgs, ... }:

{
  flakeUtils = import ./flakeUtils.nix input;
}
