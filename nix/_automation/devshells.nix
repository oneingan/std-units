{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    # `default` is a special target in newer nix versions
    # see: harvesting below
    default = {
      name = "std-units";
      # make `std` available in the numtide/devshell
      imports = [ std.std.devshellProfiles.default ];
    };
  }
