{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "openziti";
  version = "0.30.4";

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti";
    rev = "v${version}";
    hash = "sha256-4hLE1fOcYUHryQ2AqifjIynMrBm4q5c7jkkwXFja7nI=";
  };
  
  vendorHash = "sha256-Wjxr4Vaees0zR1red3yLgoF3RROohG9c3xD1YSosUCc=";

  postPatch = ''
    substituteInPlace common/version/info_generated.go \
      --replace "v0.0.0" "v${version}"
  '';

  subPackages = [ "ziti" ];
  
  meta = with lib; {
    homepage = "https://github.com/openziti/ziti";
    description = "The parent project for OpenZiti. Here you will find the executables for a fully zero trust, application embedded, programmable network";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oneingan ];
  };
}
