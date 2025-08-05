{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;
  oreo = pkgs.callPackage ../personalPKGS/oreo.nix { };
in
{
  stylix = {
    enable = true;
    autoEnable = false;
    targets.font-packages.enable = true;
    #targets.fontconfig.enable = true;
    targets.gtk.enable = true;
    targets.kde.enable = true;
    targets.qt.enable = true;
    targets.vscode.enable = true;
    targets.lazygit.enable = true;
    targets.foot.enable = true;
    targets.river.enable = true;
    targets.hyprland.enable = true;
    targets.waybar.enable = true;
    targets.nixcord.enable = true;
    targets.zen-browser = {
      enable = true;
      profileNames = [ "default" ];
    };
    iconTheme = {
      enable = true;
      package = lib.mkForce pkgs.dracula-icon-theme;
      light = "Dracula";
      dark = "Dracula";
    };
    polarity = "dark";
    image = ../assets/Wallpapers/001.jpg;
    base16Scheme = {
      base00 = "${palette.base00}";
      base01 = "${palette.base01}";
      base02 = "${palette.base02}";
      base03 = "${palette.base03}";
      base04 = "${palette.base04}";
      base05 = "${palette.base05}";
      base06 = "${palette.base06}";
      base07 = "${palette.base07}";
      base08 = "${palette.base08}";
      base09 = "${palette.base09}";
      base0A = "${palette.base0A}";
      base0B = "${palette.base0B}";
      base0C = "${palette.base0C}";
      base0D = "${palette.base0D}";
      base0E = "${palette.base0E}";
      base0F = "${palette.base0F}";
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
      #monospace = {
      #  package = pkgs.dejavu_fonts;
      #  name = "DejaVu Sans Mono";
      #};
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
