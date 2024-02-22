{ lib
, stdenvNoCC
#, fetchFromGitHub
, fetchurl
, gtk-engine-murrine
, gnome-themes-extra
, gnome-icon-theme
, gtk3
, breeze-icons
, hicolor-icon-theme
, jdupes
}:

stdenvNoCC.mkDerivation {
  pname = "kora-yellow";
  version = "1.6.4";

#  src = fetchFromGitHub {
#    owner = "bikass";
#    repo = "kora";
#    rev = "v1.6.0";
#    hash = "sha256-YKdqV41HlQMvkyWoWbOCMUASshnEDnXtxzdmJdTEQGw=";
#  };
   src = fetchurl {
    url = "https://files04.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE3MDcwNzQ3NTUiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjA5ZDFhMmM4OGUxMjhkNTZiYjQwN2ViYzlhNGE3ZGE5NjJjZGQ2ZTE0OGQ1NmZlMTQ4NjNlNzE4MTM0OTk0ZDBjOWQ3ZWU0NGU2NGU3YWYzNjY1MmE5ZDFiMzE5MWM2Yjg5ZGVjYWQxNmU3NjdkYWZkMmU4MjJjZGE1MWU1MTZkIiwidCI6MTcwNzkyMDMxNCwic3RmcCI6bnVsbCwic3RpcCI6bnVsbH0.moOYmumSsDeNE-2rWGHJNpipTXtOh9a_7TtZ_Z3qKOE/kora-yellow-1-6-4.tar.xz";
    sha256 = "sha256-5kDROLHrFfK5gx5ji5R2JkbdDvyvK75/kKFSlj4yZrg=";
   };
   sourceRoot = ".";

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;


  propagatedBuildInputs = [gtk-engine-murrine breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/kora-yellow
    cp -r kora_yellow/kora-yellow/* $out/share/icons/kora-yellow/
    gtk-update-icon-cache -f $out/share/icons/kora-yellow
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';


  meta = with lib; {
    description = "kora Icon theme";
    homepage = "https://github.com/bikass/kora";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mrfluffy ];
  };
}
