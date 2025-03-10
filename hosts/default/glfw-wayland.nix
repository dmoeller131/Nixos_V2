{
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  lib,
  ...
}:
{
  with pkgs; prismlauncher.override {
  glfw = (let
    mcWaylandPatchRepo = fetchFromGitHub {
      owner = "Admicos";
      repo = "minecraft-wayland";
      rev = "370ce5b95e3ae9bc4618fb45113bc641fbb13867";
      sha256 =
        "sha256-RPRg6Gd7N8yyb305V607NTC1kUzvyKiWsh6QlfHW+JE=";
    };
    mcWaylandPatches = map (name: "${mcWaylandPatchRepo}/${name}")
      (lib.naturalSort (builtins.attrNames (lib.filterAttrs
        (name: type:
          type == "regular" && lib.hasSuffix ".patch" name)
        (builtins.readDir mcWaylandPatchRepo))));
  in glfw-wayland.overrideAttrs (previousAttrs: {
    patches = previousAttrs.patches ++ mcWaylandPatches;
  })
}