{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib rustPlatform writeShellScript udev pkg-config;
  inherit (cell.sources.swhkd) pname version src cargoLock;

  swhkd = writeShellScript "swhkd" ''
    DIR="$(cd "$(dirname "$0")" && pwd)"
    if [ "$1" = "stop" ]; then
      pkill swhkd
      #exit 0
    else
      "$DIR"/.swhkd-wrapped $@
      #exit 0
    fi
  '';
in {
  swhkd = rustPlatform.buildRustPackage {
    inherit pname version src;
    cargoLock = cargoLock."Cargo.lock";

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      udev
    ];

    postBuild = ''
      $src/scripts/build-polkit-policy.sh \
      --swhkd-path=$out/bin/swhkd
    '';

    postInstall = ''
      install -D ./com.github.swhkd.pkexec.policy -t $out/share/polkit-1/actions
      mv $out/bin/swhkd $out/bin/.swhkd-wrapped
      cp ${swhkd} $out/bin/swhkd
    '';

    meta = with lib; {
      description = "Sxhkd clone for Wayland (works on TTY and X11 too)";
      homepage = "https://github.com/waycrate/swhkd";
      license = licenses.bsd2;
      maintainers = [maintainers.uningan];
    };
  };
}
