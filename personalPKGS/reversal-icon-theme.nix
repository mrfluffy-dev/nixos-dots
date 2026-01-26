{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  jdupes,
  adwaita-icon-theme,
  hicolor-icon-theme,
  numix-icon-theme-circle,
  colorVariants ? [ "black" ],
}:

let
  pname = "reversal-icon-theme";
in
lib.checkListOfEnum "${pname}: color variants" [
  "black"
  "blue"
  "brown"
  "cyan"
  "green"
  "grey"
  "lightblue"
  "orange"
  "pink"
  "purple"
  "red"
  "all"
] colorVariants

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Reversal-icon-theme";
    rev = "26b97f00640cd9eaeb8f196eda3a8d298158a08f";
    hash = "sha256-ahnp25wTCTrOtJUbAIv7vvVC2am+idEokoRomRe5aKU=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
    numix-icon-theme-circle
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    ./install.sh -d $out/share/icons -t ${toString colorVariants}

    # remove file that conflicts with other packages (e.g. gruvbox-dark-icons-gtk)
    find $out/share/icons -name 'LICENSE' -delete

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  dontFixup = true;

  passthru.updateScript = lib.maintainers.update-source-version {
    src = "https://github.com/yeyushengfan258/${pname}";
    versionType = "commit";
  };

  meta = with lib; {
    description = "Colorful Design rectangular icon theme for Linux desktops";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
