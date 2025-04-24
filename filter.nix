{
  lib,
  ...
}:
{
  # NOTE: just testing filtering. kinda works, but still needs to filter out
  # non-allowed files
  projectDirectories =
    with lib.fileset;
    let
      names =
        name: type:
        if type == "directory" then
          [ (baseDirectory + "/${name}") ]
        # nothing else should be kept in this directory reserved for projects
        else
          assert elem name allowedFiles;
          [ ];
      allowedFiles = unions [
        ./README.md
        ./default.nix
        ./models.nix
      ];
      filteredFiles = fileFilter (file: file.name == "default.nix") ./.;
      trackedFiles = intersection (difference filteredFiles allowedFiles) (gitTracked ../.);
      projectFiles = toList trackedFiles;
    in
    # TODO: use fileset and filter for `gitTracked` files
    projectFiles;
}
