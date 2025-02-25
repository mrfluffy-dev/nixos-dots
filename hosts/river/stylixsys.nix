{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;
  oreo = pkgs.callPackage ../../universal/personalPKGS/oreo.nix { };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    image = ../../universal/wallpapers/138.png;
    base16Scheme = {
      base00 = "#141414";
      base01 = "#303030";
      base02 = "#353535";
      base03 = "#4A4A4A";
      base04 = "#707070";
      base05 = "#cdcdcd";
      base06 = "#e5e5e5";
      base07 = "#ffffff";
      base08 = "#f92672";
      base09 = "#fd971f";
      base0A = "#e6db74";
      base0B = "#a6e22e";
      base0C = "#708387";
      base0D = "#66d9ef";
      base0E = "#9e6ffe";
      base0F = "#e8b882";
    };
    fonts = {
      serif = {
        package = pkgs.open-sans;
        name = "Open Sans";
      };
      sansSerif = {
        package = pkgs.open-sans;
        name = "Open Sans";
      };
      monospace = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 14;
        terminal = 16;
      };
    };
    cursor = {
      package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
      name = "oreo_spark_pink_cursors";
      size = 32;
    };
  };
}
