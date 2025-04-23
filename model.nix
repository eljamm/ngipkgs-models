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

  option = type: nullOr type;
  optionalAttrs = t: option (attrsOf t);
  urlType = str;

  struct =
    attrs:
    option (submodule {
      options = attrs;
    });

  optionalStruct = attrs: option (struct attrs);

  subgrantType = optionalStruct (
    lib.genAttrs [ "Commons" "Core" "Entrust" "Review" ] (
      name:
      mkOption {
        type = listOf str;
        default = [ ];
      }
    )
  );
in
{
  options.projects.Omnom = {
    name = mkOption {
      type = option str;
      default = null;
    };
    metadata = mkOption {
      type = optionalStruct {
        summary = mkOption {
          type = option str;
          default = null;
        };
        subgrants = mkOption {
          type = either (listOf str) subgrantType;
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
