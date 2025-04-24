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

  nonEmtpyAttrs = lib.mkOptionType {
    name = "nonEmtpyAttrs";
    description = "non-empty attribute set";
    check = x: lib.isAttrs x && x != { };
  };

  moduleType =
    with types;
    oneOf [
      path
      attrs
      (functionTo attrs)
    ];

  exampleType =
    with types;
    submodule {
      options = {
        module = mkOption {
          type = moduleType;
        };
        description = mkOption {
          type = str;
        };
        tests = mkOption {
          # FIX: attempt to call something which is not a function but a set
          type = nonEmtpyAttrs testType;
        };
        links = mkOption {
          type = nullOr (attrsOf (nullOr urlType));
          default = null;
        };
      };
    };

  # TODO: plugins are actually component *extensions* that are of component-specific type,
  #       and which compose in application-specific ways defined in the application module.
  #       we can't express that with yants, but with the module system, which gives us a bit of dependent typing.
  #       this also means that there's no fundamental difference between programs and services,
  #       and even languages: libraries are just extensions of compilers.
  # TODO: implement this, now that we're using the module system
  pluginType = with types; anything;

  # TODO: make use of modular services https://github.com/NixOS/nixpkgs/pull/372170
  serviceType =
    with types;
    submodule {
      options = {
        name = mkOption {
          type = nullOr str;
          default = null;
        };
        module = mkOption {
          type = moduleType;
        };
        examples = mkOption {
          type = nullOr (attrsOf (nullOr exampleType));
          default = null;
        };
        extensions = mkOption {
          type = nullOr (attrsOf (nullOr pluginType));
          default = null;
        };
        links = mkOption {
          type = nullOr (attrsOf (nullOr urlType));
          default = null;
        };
      };
    };

  # NixOS tests are modules that boil down to a derivation
  testType = with types; nullOr (either moduleType package);
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
    nixos = mkOption {
      type =
        with types;
        submodule {
          options = {
            # programs = optionalAttrs (option programType);
            services = mkOption {
              type = nullOr (attrsOf (nullOr serviceType));
              default = null;
            };
          };
        };
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

    nixos.services.omnom = {
      module = "${sources.nixpkgs}/nixos/modules/services/misc/omnom.nix";
      examples.base = {
        module = { ... }: { };
        description = "Basic Omnom configuration, mainly used for testing purposes";
        tests = {
          basic = null;
        };
      };
    };
  };
}
