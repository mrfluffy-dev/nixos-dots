{ config
, stdenv
, fetchurl
, lib
, unzip
, steam-run
, mpv
}:


let
  pname = "mangayomi";
  version = "0.1.85";
in


stdenv.mkDerivation {
  name = "${pname}";
  version = "${version}";
  src = fetchurl {
    url = "https://github.com/kodjodevf/mangayomi/releases/download/v0.1.85/Mangayomi-v0.1.85-linux.zip";
    hash = "sha256-9GDJnBGWBRlm5NasfSR0SQGhYLcRnjMclQDU+vX+c4E=";
  };
  nativeBuildInputs = [ ];

  runtimeDependencies = [ steam-run mpv ];

  dontUnpack = true;
  dontRewriteSymlinks = true;

  propagatedBuildInputs = [ unzip ];

  installPhase = ''
    unzip $src
    mkdir -p $out/bin
    touch $out/runmangayomi
    echo "#!/bin/sh steam-run /nix/store/$(ls -la /nix/store | grep 'mangayomi' | grep '^d' | awk '$0=$NF' | head -n 2)/mangayomi" >> $out/runmangayomi
    chmod +x $out/runmangayomi
    ln -s $out/runmangayomi $out/bin/mangayomi
    install -Dm755 mangayomi $out/mangayomi
    mkdir -p $out/lib
    cp -r lib/* $out/lib
    mkdir -p $out/data
    cp -r data/* $out/data
    runHook postInstall
  '';


  meta = with lib; {
    description = "Free and open source application for reading manga and watching anime available on Android, iOS, macOS, Linux and Windows ";
    homepage = "https://github.com/kodjodevf/mangayomi";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ mrfluffy ];
  };
}
