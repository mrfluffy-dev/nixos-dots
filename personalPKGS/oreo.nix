{
  config,
  stdenv,
  fetchurl,
  lib,
  colors ? [ "oreo_white_cursors" ],
}:

let
  pname = "oreo-cursors";

in
lib.checkListOfEnum "${pname}: color variants"
  [
    "oreo_white_cursors"
    "oreo_teal_cursors"
    "oreo_red_cursors"
    "oreo_purple_cursors"
    "oreo_pink_cursors"
    "oreo_grey_cursors"
    "oreo_blue_cursors"
    "oreo_black_cursors"
    "oreo_spark_violet_cursors"
    "oreo_spark_red_cursors"
    "oreo_spark_purple_cursors"
    "oreo_spark_pink_cursors"
    "oreo_spark_orange_cursors"
    "oreo_spark_lite_cursors"
    "oreo_spark_lime_cursors"
    "oreo_spark_light_pink_cursors"
    "oreo_spark_green_cursors"
    "oreo_spark_dark_cursors"
    "oreo_spark_blue_cursors"
    "all"
  ]
  colors

  stdenv.mkDerivation
  {
    name = "${pname}";
    version = "final";
    src = fetchurl {
      url = "https://github.com/mrfluffy-dev/oreo-cursor/releases/download/v1/final.tar.gz";
      hash = "sha256-b10pr119XrP8qAj5U0kOJ061pbqv27iCEeVIvT7w5bk=";
    };
    nativeBuildInputs = [ ];

    dontRewriteSymlinks = true;

    propagatedBuildInputs = [ ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      # see if colors has "all" in it, if so, use all the colors
      if [[ " ${builtins.toString colors} " =~ " all " ]]; then
         cp -r * $out/share/icons/
      else
        for color in ${builtins.toString colors}; do
            cp -r $color $out/share/icons/
        done
      fi

      runHook postInstall
    '';

    meta = with lib; {
      description = "oreo-cursors but purple";
      homepage = "https://github.com/varlesh/oreo-cursors?tab=readme-ov-file";
      platforms = platforms.linux;
      license = licenses.gpl2;
      maintainers = with maintainers; [ mrfluffy ];
    };
  }
