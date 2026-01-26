{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.colorScheme) palette;
  oreo = pkgs.callPackage ../personalPKGS/oreo.nix { };
  openSans = {
    package = pkgs.open-sans;
    name = "Open Sans";
  };
in
{
  stylix = {
    enable = true;
    autoEnable = false;

    targets = {
      font-packages.enable = true;
      # fontconfig.enable = true;

      #gtk = {
      #  enable = true;
      #  flatpakSupport.enable = true;
      #};
      #kde.enable = true;

      #qt.enable = true;
      #vscode.enable = true;
      lazygit.enable = true;
      #foot.enable = true;
      #river.enable = true;
      #hyprland.enable = true;
      #waybar.enable = true;
      #nixcord.enable = true;

      #zen-browser = {
      #  enable = true;
      #  profileNames = [ "default" ];
      #};
      #firefox = {
      #  enable = true;
      #  profileNames = [ "default" ];
      #};
    };

    #iconTheme = {
    #  enable = true;
    #  #package = lib.mkForce (pkgs.reversal-icon-theme.override { allColorVariants = true; });
    #  light = "Reversal-black";
    #  dark = "Reversal-black-dark";
    #};

    polarity = "dark";
    image = ../assets/Wallpapers/001.jpg;

    base16Scheme = {
      inherit (palette)
        base00 base01 base02 base03 base04 base05 base06 base07
        base08 base09 base0A base0B base0C base0D base0E base0F;
    };

    fonts = {
      serif = openSans;
      sansSerif = openSans;

      # monospace = {
      #   package = pkgs.dejavu_fonts;
      #   name = "DejaVu Sans Mono";
      # };
      monospace = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 14;
        terminal = 16;
      };
    };

    #cursor = {
    #  package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
    #  name = "oreo_spark_pink_cursors";
    #  size = 32;
    #};
  };
}
