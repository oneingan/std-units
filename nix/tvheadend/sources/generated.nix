# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  tvheadend = {
    pname = "tvheadend";
    version = "18effa8ad93e901f3cdaa534123d910f14453d1f";
    src = fetchFromGitHub {
      owner = "tvheadend";
      repo = "tvheadend";
      rev = "18effa8ad93e901f3cdaa534123d910f14453d1f";
      fetchSubmodules = false;
      sha256 = "sha256-v4qfZku6SOUtYUJnlMHBomgMu3bV853G4fDidc2wdS8=";
    };
    date = "2023-04-19";
  };
}
