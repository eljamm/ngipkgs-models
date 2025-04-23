{
  sources ? {
    nixpkgs = <nixpkgs>;
  },
  pkgs ? import sources.nixpkgs {
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
  lib ? import "${sources.nixpkgs}/lib",
}:
rec {
  models = import ./model.nix { inherit pkgs lib sources; };

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
      ++ [ models ];
    specialArgs = {
      modulesPath = "${sources.nixpkgs}/nixos/modules";
    };
  };
}
