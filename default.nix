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
  inherit
    lib
    pkgs
    ;

  models = import ./model.nix { inherit pkgs lib sources; };

  nixosModules = import "${sources.nixpkgs}/nixos/modules/module-list.nix";

  raw-projects = import ./projects {
    inherit lib pkgs;
    sources = {
      inputs = sources;
    };
  };

  # NOTE: maybe we shouldn't have empty attrs to begin with and just use null
  # by default
  projects = lib.filterAttrsRecursive (
    n: v: (v != null) && (v != { })
  ) evaluated-modules.config.projects;

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
      ++ [ raw-projects ];
    specialArgs = {
      modulesPath = "${sources.nixpkgs}/nixos/modules";
    };
  };
}
