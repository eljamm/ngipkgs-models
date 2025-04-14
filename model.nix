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

  config = {
    project-models.name = "hello";
    project-models.metadata.summary = "hello";
  };
}
