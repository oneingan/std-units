{ lib, stdenv, fetchzip, autoPatchelfHook,
python3, python3Packages, libz, ffmpeg_4-headless }:

stdenv.mkDerivation rec {
  pname = "acestream-engine";
  version = "3.1.75rc4";

  src = fetchzip {
    url = "https://download.acestream.media/linux/acestream_${version}_ubuntu_18.04_x86_64_py3.8.tar.gz";
    hash = "sha256-2vVQq7VsLui4uv9nPyxYISn2HLi/iBPAOVEowyxa3jc=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    python3
    libz
    ffmpeg_4-headless
  ];

  pythonEnv = python3.withPackages (p: with p; [
    pycryptodome
    lxml
    apsw
    psutil
    pynacl
    # iso8601
  ]);
  
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp acestreamengine $out/bin

    wrapProgram "$out/bin/acestreamengine" \
      --prefix PYTHONPATH : "${pythonEnv}/${python3.sitePackages}"

    cp -r lib $out/bin/
    cp -r data $out/bin/
    runHook postInstall
  '';

  postFixup = "wrapPythonPrograms";
}
