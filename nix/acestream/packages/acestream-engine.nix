{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, python310
, python3
, ffmpeg_4
, zlib
, sqlite
, libffi
, openssl
, libxml2
, libxslt
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    #requirements.txt
    pycryptodome
    lxml
    apsw
    psutil
    pynacl
    iso8601
    aiohttp
    
    #vendored
    async-timeout
    # bitarray
    certifi
    # cffi
    multidict
    sentry-sdk
    setuptools
    sortedcontainers
    typing-extensions
    urllib3
  ]);
in
stdenv.mkDerivation rec {
  pname = "acestream-engine";
  version = "3.2.11";

  src = fetchzip {
    url = "https://download.acestream.media/linux/acestream_${version}_ubuntu_22.04_x86_64_py3.10.tar.gz";
    hash = "sha256-0DaxzK4lXYE3kP7bOwE/35r3Jd99YRsTzum6T94myeY=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    python310
    ffmpeg_4    # Replaces bundled ffmpeg libs
    zlib
    sqlite
    libffi
    openssl
    libxml2
    libxslt
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/acestream
    mkdir -p $out/bin

    cp -a . $out/opt/acestream/

    # REMOVE bundled FFmpeg and other libraries 
    # This forces autoPatchelf to find them in buildInputs (Nixpkgs)
    rm -rf $out/opt/acestream/lib/*
    # rm -rf $out/opt/acestream/lib/*.whl
    # rm -rf $out/opt/acestream/lib/*.egg
    rm -rf $out/opt/acestream/acestream.conf
    cp -r lib/acestreamengine $out/opt/acestream/lib/.
    cp -r lib/modules.zip $out/opt/acestream/lib/.
    cp -r lib/bitarray-* $out/opt/acestream/lib/.
    # cp -r lib/sentry_sdk-* $out/opt/acestream/lib/.
    

    # Wrap the main binary
    makeWrapper $out/opt/acestream/acestreamengine $out/bin/acestream-engine \
      --prefix PATH : "${pythonEnv}/bin" \
      --set PYTHONPATH "./lib:${pythonEnv}/${python3.sitePackages}" \
      --prefix LD_LIBRARY_PATH : "$out/opt/acestream/acestreamengine/lib:${lib.makeLibraryPath buildInputs}" \
      --chdir "$out/opt/acestream"

    install -Dm644 acestream.conf $out/etc/acestream.conf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ace Stream engine using system FFmpeg 4";
    homepage = "https://acestream.org";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
