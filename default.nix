{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
  lib ? pkgs.lib,
}:
{
  model = import ./model.nix { };
}
