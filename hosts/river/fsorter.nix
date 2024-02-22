{ config
, stdenvNoCC
, fetchFromGitHub
, lib
, pkgs
, cmake
, gcc
,
  ... }:



stdenvNoCC.mkDerivation {
  pname = "fsorter";
  version = "1";

  src = fetchFromGitHub {
    owner = "mrfluffy-dev";
    repo = "fsorter";
    rev = "v1";
    hash = "sha256-oIMdNYhvhdahJVQRvNSNd1EAw+JIbSWQLwSUZEUeah0=";
  };
  nativeBuildInputs = [ gcc ];


  dontRewriteSymlinks = true;


  propagatedBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cmake .
    make
    install -Dm755 fsorter $out/bin/fsorter
    runHook postInstall
  '';


  meta = with lib; {
    description = "ez file sorter";
    homepage = "https://github.com/mrfluffy-dev/fsorter";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mrfluffy ];
  };
}
