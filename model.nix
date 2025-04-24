{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    ;

  subgrantType =
    with types;
    submodule {
      options = lib.genAttrs [ "Commons" "Core" "Entrust" "Review" ] (
        name:
        mkOption {
          type = listOf str;
          default = [ ];
        }
      );
    };

  urlType =
    with types;
    submodule {
      options = {
        # link text
        text = mkOption { type = str; };
        # could be a hover/alternative text or simply a long-form description of a non-trivial resource
        description = mkOption {
          type = nullOr str;
          default = null;
        };
        # we may later want to do a fancy syntax check in a custom `typdef`
        url = mkOption { type = str; };
      };
    };

  binaryType =
    with types;
    submodule {
      options = {
        name = mkOption {
          type = nullOr str;
          default = null;
        };
        data = mkOption {
          type = nullOr (either path package);
          default = null;
        };
      };
    };
in
{
  options.projects.Omnom = {
    name = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    metadata = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = {
            summary = mkOption {
              type = nullOr str;
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
        });
      default = null;
    };
    binary = mkOption {
      type = with types; attrsOf binaryType;
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
