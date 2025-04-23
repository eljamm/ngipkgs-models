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
    either
    listOf
    ;

  option = t: nullOr t;
  optionalAttrs = t: option (attrsOf t);
  urlType = str;

  optionalStruct = as: optionalAttrs (submodule as);

  subgrantType = submodule {
    options = {
      Commons = mkOption {
        type = listOf str;
      };
      Core = mkOption {
        type = listOf str;
      };
      Entrust = mkOption {
        type = listOf str;
      };
      Review = mkOption {
        type = listOf str;
      };
    };
  };
in
{
  options.projects.Omnom = {
    name = mkOption {
      type = option str;
      default = null;
    };
    metadata = mkOption {
      type = submodule {
        options = {
          summary = mkOption {
            type = option str;
            default = null;
          };
          subgrants = mkOption {
            type = either (listOf str) subgrantType;
          };
        };
      };
      default = null;
    };
  };

  config.projects.Omnom = {
    metadata = {
      summary = "Omnom is a webpage bookmarking and snapshotting service.";
      subgrants = {
        Core = [
          "omnom"
          "omnom-ActivityPub"
        ];
      };
    };

    # nixos.modules.services.omnom = {
    #   module = "${sources.nixpkgs}/nixos/modules/services/misc/omnom.nix";
    #   examples.base = {
    #     module = { ... }: { };
    #     description = "Basic Omnom configuration, mainly used for testing purposes";
    #     tests.basic = null;
    #   };
    # };
  };
}
