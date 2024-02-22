{ pkgs, lib, config, ... }:
let inherit (config.colorScheme) palette;
in {
  stylix = {
    autoEnable = false;
    targets.gtk.enable = true;
    polarity = "dark";
    image = ../../universal/wallpapers/001.jpg;
    base16Scheme = {
      base00 = "${config.colorScheme.colors.base00}";
      base01 = "${config.colorScheme.colors.base01}";
      base02 = "${config.colorScheme.colors.base02}";
      base03 = "${config.colorScheme.colors.base03}";
      base04 = "${config.colorScheme.colors.base04}";
      base05 = "${config.colorScheme.colors.base05}";
      base06 = "${config.colorScheme.colors.base06}";
      base07 = "${config.colorScheme.colors.base07}";
      base08 = "${config.colorScheme.colors.base08}";
      base09 = "${config.colorScheme.colors.base09}";
      base0A = "${config.colorScheme.colors.base0A}";
      base0B = "${config.colorScheme.colors.base0B}";
      base0C = "${config.colorScheme.colors.base0C}";
      base0D = "${config.colorScheme.colors.base0D}";
      base0E = "${config.colorScheme.colors.base0E}";
      base0F = "${config.colorScheme.colors.base0F}";
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
  };
}
