# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  swhkd = {
    pname = "swhkd";
    version = "3b19fc33b32efde88311579152a1078a8004397c";
    src = fetchFromGitHub {
      owner = "waycrate";
      repo = "swhkd";
      rev = "3b19fc33b32efde88311579152a1078a8004397c";
      fetchSubmodules = false;
      sha256 = "sha256-245Y3UicW33hrQ6Mtf07I9vsWSpuijIEoEhxIKtjVQE=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./swhkd-3b19fc33b32efde88311579152a1078a8004397c/Cargo.lock;
      outputHashes = {
      };
    };
    date = "2022-12-23";
  };
}
