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

  optional =
    type:
    mkOption {
      type = option type;
      default = null;
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
    text = mkOption { type = str; };
    # could be a hover/alternative text or simply a long-form description of a non-trivial resource
    description = optional str;
    # we may later want to do a fancy syntax check in a custom `typdef`
    url = mkOption { type = str; };
  };

  binaryType = struct {
    name = optional str;
    data = optional (either path package);
  };
in
{
  options.projects.Omnom = {
    name = optional str;
    metadata = mkOption {
      type = optionalStruct {
        summary = optional str;
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
