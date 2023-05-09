{
  description = "The Hive - The secretly open NixOS-Society";

  inputs = {
    paisano.url = "github:paisano-nix/core";
    paisano.inputs.nixpkgs.follows = "nixpkgs";
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.paisano.follows = "paisano";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    std-data-collection.url = "github:divnix/std-data-collection";
    std-data-collection.inputs.std.follows = "std";
    std-data-collection.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    std,
    self,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        # reusable software
        {
          name = "sources";
          type = "nvfetcher";
          actions = {
            currentSystem,
            target,
            fragment,
            fragmentRelPath,
          }: [
            {
              name = "update";
              description = "Update generated nix expression";
              command = inputs.nixpkgs.legacyPackages.${currentSystem}.writeShellScript "sources-update" ''
                ${inputs.nixpkgs.legacyPackages.${currentSystem}.nvfetcher}/bin/nvfetcher --config $(nix build ${builtins.unsafeDiscardStringContext target.drvPath} --no-link --print-out-paths) --build-dir $PRJ_ROOT/_sources/
              '';
            }
          ];
        }
        (installables "packages")

        # modules implement
        (functions "modules")
        (functions "hm-modules")

        # devshells can be entered
        (devshells "devshells")
      ];
      nixpkgsConfig = {
        allowUnfree = true;
      };
    }
    # soil
    {
      # packages = std.harvest self ["tow-boot" "packages"];
      devShells = std.harvest self ["_automation" "devshells"];
    };
}
