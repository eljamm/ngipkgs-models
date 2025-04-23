{
  nixpkgs ? <nixpkgs>,
  pkgs ? import nixpkgs {
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
  lib ? import "${nixpkgs}/lib",
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
rec {
  sources.nixpkgs = nixpkgs;

  model = import ./model.nix { inherit pkgs lib sources; };

  nixosModules = import "${sources.nixpkgs}/nixos/modules/module-list.nix";

  evaluated-modules = lib.evalModules {
    modules =
      [
        {
          config = {
            nixpkgs.hostPlatform = { inherit system; };

            networking = {
              domain = "invalid";
              hostName = "options";
            };

            system.stateVersion = "23.05";
          };
        }
      ]
      ++ nixosModules
      ++ [ model ];
    specialArgs = {
      modulesPath = "${sources.nixpkgs}/nixos/modules";
    };
  };
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
