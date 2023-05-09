{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  unzip,
  dpkg,
  bash,
  adoptopenjdk-jre-bin,
  libressl,
}: let
  java = adoptopenjdk-jre-bin;
in
  stdenv.mkDerivation rec {
    pname = "autofirma";
    version = "1.7.1";

    src = fetchurl {
      url = "https://estaticos.redsara.es/comunes/autofirma/${
        builtins.replaceStrings ["."] ["/"] version
      }/AutoFirma_Linux.zip";
      hash = "sha256-bNYaWciKlJvdO4GwYOrIDN2mcQWtf3UpoqHu2RbotmA=";
    };

    desktopItem = makeDesktopItem {
      name = "AutoFirma";
      desktopName = "AutoFirma";
      exec = "autofirma %u";
      icon = "autofirma";
      mimeTypes = ["x-scheme-handler/afirma"];
      categories = ["Office"];
    };

    buildInputs = [libressl bash dpkg unzip makeWrapper];
    nativeBuildInputs = [java];

    unpackPhase = ''
      unzip $src AutoFirma_${builtins.replaceStrings ["."] ["_"] version}.deb
      dpkg-deb -x AutoFirma_${
        builtins.replaceStrings ["."] ["_"] version
      }.deb .
    '';

    buildPhase = ''
      ${java}/bin/java -jar usr/lib/AutoFirma/AutoFirmaConfigurador.jar
    '';

    installPhase = ''
      install -Dm644 usr/lib/AutoFirma/AutoFirma.jar $out/share/autofirma/autofirma.jar
      install -Dm644 usr/lib/AutoFirma/autofirma.pfx $out/share/autofirma/autofirma.pfx
      install -Dm644 usr/lib/AutoFirma/AutoFirma_ROOT.cer $out/share/autofirma/AutoFirma_ROOT.cer
      install -Dm644 usr/share/AutoFirma/AutoFirma.svg $out/share/autofirma/autofirma.svg
      install -Dm644 usr/lib/AutoFirma/AutoFirma.png $out/share/pixmaps/autofirma.png

      install -d $out/bin
      makeWrapper ${java}/bin/java $out/bin/${pname} \
        --add-flags "-jar $out/share/autofirma/autofirma.jar $*"

      ${libressl}/bin/openssl x509 -inform DER -in usr/lib/AutoFirma/AutoFirma_ROOT.cer -out usr/lib/AutoFirma/AutoFirma_ROOT.crt
      install -Dm644 usr/lib/AutoFirma/AutoFirma_ROOT.crt $out/share/ca-certificates/trust-source/anchors/AutoFirma_ROOT.crt

      mkdir -p $out/share/applications
      ln -s ${desktopItem}/share/applications/* $out/share/applications/
    '';

    meta = with lib; {
      description = "Spanish Government digital signature tool";
      homepage = "https://firmaelectronica.gob.es/Home/Ciudadanos/Aplicaciones-Firma.html";
      license = with licenses; [gpl2Only eupl11];
      platforms = platforms.linux;
    };
  }
