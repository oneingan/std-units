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
    emacsPgtk
    
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

  agitate = emacsPackages.elpaBuild {
    pname = "agitate";
    ename = "agitate";
    version = "0.0.20221023.11841";
    src = fetchurl {
      url = "https://elpa.gnu.org/devel/agitate-0.0.20221023.11841.tar";
      sha256 = "sha256-fCGnBUVqZtMI4RhYShsF0BUEzouJaJ61doA+nqGXGIc=";
    };
    packageRequires = [emacs];
    meta = {
      homepage = "https://elpa.gnu.org/packages/ace-window.html";
      license = lib.licenses.free;
    };
  };

  extraPackages = epkgs:
    with epkgs;
      [
        # prot
        agitate # Not in ELPA yet
        altcaps
        beframe
        bongo
        cape
        citar
        citar-denote
        citar-embark
        consult
        consult-dir
        corfu
        cursory
        denote
        diff-hl
        dired-subtree
        ebdb
        ef-themes
        elfeed
        elfeed-tube
        elfeed-tube-mpv
        elpher
        embark
        embark-consult
        evil
        exec-path-from-shell
        flymake-diagnostic-at-point
        flymake-proselint
        flymake-shellcheck
        fontaine
        goto-last-change
	      inputs.nixpkgs.emacsPackages.jinx
        js-comint
        keycast
        lin
        logos
        magit
        marginalia
        markdown-mode
        mct
        minions
        modus-themes
        mpv
        nix-mode
        notmuch-indicator
        notmuch-addr
        olivetti
        ol-notmuch
        orderless
        org-modern
        osm
        package-lint-flymake
        pass
        password-store
        pcmpl-args
        plz
        pulsar
        rainbow-mode
        recursion-indicator
        sxhkdrc-mode
        substitute
        tempel
        terraform-mode
        tmr
        transpose-frame
        trashed
        vertico
        vterm
        which-key
        wgrep
        yaml-mode
      ]
      ++ [
        # user
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

  finalEmacs = (emacsPackagesFor emacsPgtk).emacsWithPackages extraPackages;
in {
  prot-emacs = finalEmacs;
}
