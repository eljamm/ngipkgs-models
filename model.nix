{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib)
    mkOption
    ;

  inherit (lib.types)
    attrs
    attrsOf
    list
    nullOr
    str
    submodule
    ;

  option = t: nullOr t;
  optionalAttrs = t: option (attrsOf t);
  urlType = str;

  optionalStruct = as: optionalAttrs (submodule as);
in
{
  options.project-models = {
    name = mkOption {
      type = option str;
      default = null;
    };
    metadata = mkOption {
      type = optionalStruct {
        options = {
          sumamry = lib.mkOption {
            type = option str;
            default = null;
          };
        };
      };
      default = null;
    };
  };

  config.Omnom = {
    metadata = {
      summary = "Omnom is a webpage bookmarking and snapshotting service.";
      subgrants = [
        "omnom"
        "omnom-ActivityPub"
      ];
    };

    nixos.modules.services.omnom = {
      module = "${sources.inputs.nixpkgs}/nixos/modules/services/misc/omnom.nix";
      examples.base = {
        module = ./example.nix;
        description = "Basic Omnom configuration, mainly used for testing purposes";
        tests.basic = null;
      };
    };
  };
}
