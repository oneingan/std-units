# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  emacs-overlay = {
    pname = "emacs-overlay";
    version = "6ec96835d9328bcb245d81c5997eea2ec6144fea";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "emacs-overlay";
      rev = "6ec96835d9328bcb245d81c5997eea2ec6144fea";
      fetchSubmodules = false;
      sha256 = "sha256-Iwg/4hpKW8QYLLa+IQcLwy3BSf407IGOnRmdDRhTYdY=";
    };
  };
  modus-themes = {
    pname = "modus-themes";
    version = "0f3e96982cb2b9e78df0ee8c96f7a0de211e37e9";
    src = fetchFromGitHub {
      owner = "protesilaos";
      repo = "modus-themes";
      rev = "0f3e96982cb2b9e78df0ee8c96f7a0de211e37e9";
      fetchSubmodules = false;
      sha256 = "sha256-8MyC7/NtnqFLG3BcWLvfZniLgAUpkPtQhhxdKdYl76o=";
    };
    date = "2023-06-02";
  };
  nixpkgs-emacs = {
    pname = "nixpkgs-emacs";
    version = "5e871d8aa6f57cc8e0dc087d1c5013f6e212b4ce";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "5e871d8aa6f57cc8e0dc087d1c5013f6e212b4ce";
      fetchSubmodules = false;
      sha256 = "sha256-3uQytfnotO6QJv3r04ajSXbEFMII0dUtw0uqYlZ4dbk=";
    };
  };
}
