{
  inputs,
  cell,
}:
let
  inherit (inputs) nixpkgs;
in
{
  lieer = nixpkgs.lieer.overrideAttrs (old: {
    version = "1.4-87e85ef";
    src = nixpkgs.fetchFromGitHub {
      owner = "gauteh";
      repo = "lieer";
      rev = "244c9bfe11d87cd8a09c38ef5470e798ad41359e";
      sha256 = "sha256-CaHI8sdM1jBubszjqaOkxaDA2zZxwufgjFeDkuTHRIo=";
    };
    propagatedBuildInputs = with nixpkgs.python3Packages; [
      notmuch2 # updated to notmuch2, notmuch in nixpkgs
      oauth2client
      google-api-python-client
      tqdm
      setuptools
    ];
  });
}
