{
  pkgs,
  lib,
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
    string
    submodule
    ;

  option = t: nullOr;
  optionalAttrs = t: option (attrsOf t);
  urlType = string;

  optionalStruct = as: optionalAttrs (submodule as);
in
{
  options.project-models = {
    name = mkOption {
      type = option string;
      default = null;
    };
    metadata = mkOption {
      type = optionalStruct {
        options = {
          sumamry = lib.mkOption {
            type = option string;
            default = null;
          };
        };
      };
      default = null;
    };
  };

  config = {
    project-models.name = "hello";
    project-models.metadata.summary = 123;
  };
}
