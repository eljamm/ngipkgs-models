{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
  lib ? pkgs.lib,
}:
let
  nixosSystem =
    args:
    import (<nixpkgs> + "/nixos/lib/eval-config.nix") (
      {
        inherit lib;
        system = null;
      }
      // args
    );
in
{
  model = import ./model.nix { inherit pkgs lib; };
  project = nixosSystem {
    system = null;
    modules = [
      ./model.nix
      {
        nixpkgs.hostPlatform.system = "x86_64-linux";
      }
    ];
  };
}
