{
  lib,
  pkgs,
  sources,
  models ? import ../model.nix {
    inherit lib pkgs;
    sources = sources.inputs;
  },
}:
let
  inherit (builtins)
    elem
    readDir
    trace
    ;

  inherit (lib.attrsets)
    concatMapAttrs
    mapAttrs
    filterAttrs
    ;

  inherit (models)
    mkProject
    ;

  baseDirectory = ./.;

  projectDirectories =
    let
      names =
        name: type:
        if type == "directory" then
          { ${name} = baseDirectory + "/${name}"; }
        # nothing else should be kept in this directory reserved for projects
        else
          assert elem name allowedFiles;
          { };
      allowedFiles = [
        "README.md"
        "default.nix"
        "models.nix"
        "test.nix"
      ];
    in
    # TODO: use fileset and filter for `gitTracked` files
    concatMapAttrs names (readDir baseDirectory);
in
mapAttrs (
  name: directory: mkProject name (import directory { inherit lib pkgs sources; })
) projectDirectories
