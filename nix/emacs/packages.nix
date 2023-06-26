{
  inputs,
  cell,
}: let
  pkgs = import cell.sources.nixpkgs-emacs.src {
    system = "x86_64-linux";
    overlays = [(import cell.sources.emacs-overlay.src)];
  };

  inherit
    (pkgs)
    lib
    emacsPackages
    emacsPackagesFor
    emacs-pgtk
    
    fetchurl
    emacs
    ;

  parsePackagesFromProtElpaPackage = configText: let
    inherit (import "${cell.sources.emacs-overlay.src}/repos/fromElisp" {inherit pkgs;}) fromElisp;
    recurse = item:
      if builtins.isList item && item != []
      then
        if (builtins.head item) == "prot-emacs-elpa-package"
        then [(builtins.tail (builtins.head (builtins.tail item)))] ++ map recurse item
        else map recurse item
      else [];
  in
    lib.flatten (map recurse (fromElisp configText));

  extraPackages = epkgs:
    with epkgs;
      [
        ## prot
        elpaDevelPackages.agitate
        elpaDevelPackages.altcaps
        elpaDevelPackages.beframe
        elpaDevelPackages.cursory
        elpaDevelPackages.denote
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
        elpaDevelPackages.sxhkdrc-mode
        elpaDevelPackages.tmr
      ] ++ [
        ## third-party
        cape
        consult
        corfu
        dired-subtree
        elfeed
        embark
        embark-consult
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
        substitute
        tempel
        trashed
        vertico
        vundo
        wgrep
      ] ++ [
        ## user
        nix-mode
        terraform-mode
        vterm
        direnv
        ement
      ];
  # ++ [
  # ement
  # inputs.nixpkgs.emacsPackages.ement
  # ];

  # packages = parsePackagesFromProtElpaPackage (builtins.readFile "${inputs.prot-dotfiles}/emacs/.emacs.d/prot-emacs-modules/prot-emacs-essentials.el");

  # extraPackages = epkgs: map (name: epkgs.${name}) packages;

  finalEmacs = (emacsPackagesFor emacs-pgtk).emacsWithPackages extraPackages;
in {
  prot-emacs = finalEmacs;
}
