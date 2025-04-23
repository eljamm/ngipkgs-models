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
    either
    list
    listOf
    nullOr
    package # TODO: rename this?
    path
    str
    submodule
    ;

  option = type: nullOr type;
  optionalAttrs = type: option (attrsOf type);
  struct =
    attrs:
    submodule {
      options = attrs;
    };

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

  urlType = optionalStruct {
    # link text
    text = mkOption {
      type = str;
      default = null;
    };
    # could be a hover/alternative text or simply a long-form description of a non-trivial resource
    description = mkOption {
      type = option str;
      default = null;
    };
    # we may later want to do a fancy syntax check in a custom `typdef`
    url = mkOption {
      type = str;
      default = null;
    };
  };

  binaryType = struct {
    name = mkOption {
      type = option str;
      default = null;
    };
    data = mkOption {
      type = option (either path package);
      default = null;
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
      type = optionalStruct {
        summary = mkOption {
          type = option str;
          default = null;
        };
        subgrants = mkOption {
          type = either (listOf str) subgrantType;
          default = null;
        };
        links = mkOption {
          type = attrsOf urlType;
          default = { };
        };
      };
      default = null;
    };
    binary = mkOption {
      type = attrsOf binaryType;
      default = { };
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
      links.config = {
        text = "Config File";
        url = "https://github.com/asciimoo/omnom/blob/master/config/config.go";
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
