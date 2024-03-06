{
  description = "The Hive - The secretly open NixOS-Society";

  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    std-data-collection.url = "github:divnix/std-data-collection";
    std-data-collection.inputs.std.follows = "std";
    std-data-collection.inputs.nixpkgs.follows = "nixpkgs";
  };

  # for packages
  inputs = {
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
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
            inputs,
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
      packages = std.harvest self [
        ["autofirma" "packages"]
        ["chromium" "packages"]
        ["emacs" "packages"]
        ["firefox" "packages"]
        ["keyd" "packages"]
        ["kodi" "packages"]
        ["lieer" "packages"]
        ["minisatip" "packages"]
        ["plex" "packages"]
        ["plex-desktop" "packages"]
        ["river" "packages"]
        ["sway" "packages"]
        ["swhkd" "packages"]
        ["tvheadend" "packages"]
        ["webgrabplus" "packages"]
        ["widevine" "packages"]
        ["acestream" "packages"]
        ["yggdrasil" "packages"]
      ];

      nixosModules = std.harvest self [
        ["minisatip" "modules"]
        ["keyd" "modules"]
        ["swhkd" "modules"]
        ["tvheadend" "modules"]
        ["webgrabplus" "modules"]        
      ];

      homeModules = std.harvest self [
        ["river" "hm-modules"]
        ["swhkd" "hm-modules"]
      ];

      devShells = std.harvest self ["_automation" "devshells"];
    };
}
