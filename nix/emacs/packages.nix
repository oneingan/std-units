{
  inputs,
  cell,
}: let
  pkgs = import inputs.emacs-overlay.inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [(import inputs.emacs-overlay)];
  };

  inherit (pkgs) lib;

  # Copied from all-packages.nix, with modifications to support
  # overrides.
  emacsPackages = let epkgs = pkgs.emacsPackagesFor pkgs.emacs-pgtk;
  in epkgs.overrideScope' overrides;

  emacsWithPackages = emacsPackages.emacsWithPackages;

  extraPackages = epkgs:
    with epkgs;
      [
        ## prot
        elpaDevelPackages.agitate
        elpaDevelPackages.altcaps
        elpaDevelPackages.beframe
        elpaDevelPackages.consult-denote
        elpaDevelPackages.cursory
        elpaDevelPackages.denote
        elpaDevelPackages.dired-preview
        elpaDevelPackages.ef-themes
        elpaDevelPackages.fontaine
        elpaDevelPackages.lin
        elpaDevelPackages.logos
        elpaDevelPackages.mct
        elpaDevelPackages.modus-themes
        elpaDevelPackages.notmuch-indicator
        elpaDevelPackages.pulsar
        elpaDevelPackages.spacious-padding
        elpaDevelPackages.standard-themes
        elpaDevelPackages.substitute
        elpaDevelPackages.sxhkdrc-mode
        elpaDevelPackages.theme-buffet
        elpaDevelPackages.tmr
      ] ++ [
        ## third-party
        consult
        corfu
        csv-mode
        devil
        dired-subtree
        elfeed
        embark
        embark-consult
        exec-path-from-shell
        expreg
        breadcrumb
        goto-chg
        goto-last-change
        inputs.nixpkgs.emacsPackages.jinx
        keycast
        magit
        marginalia
        markdown-mode
        olivetti
        ol-notmuch
        orderless
        package-lint-flymake
        pass
        password-store
        rainbow-mode
        ready-player
        substitute
        tempel
        trashed
        vertico
        vundo
        wgrep
      ] ++ [
        ## user
        groovy-mode
        jenkinsfile-mode
        nix-mode
        terraform-mode
        vterm
        eat
        direnv
        ement
        forge
        consult-gh
        treesit-grammars.with-all-grammars
      ];

  overrides = self: super: {
    consult-gh = super.consult-gh.override {
      melpaBuild = args: super.melpaBuild ( args // {
        version = "20231206";
        src = pkgs.fetchFromGitHub {
          owner = "armindarvish";
          repo = "consult-gh";
          rev = "a035eac54a3be270168e86f32075e5f6f426c103";
          hash = "sha256-qZ7ra8Q8kcBDfR832rquKn8fy0UrNhonHZcX1oCz3dI=";
        };
      });
    };
  };

  finalPackage = emacsWithPackages extraPackages;
in {
  prot-emacs = finalPackage;
}
