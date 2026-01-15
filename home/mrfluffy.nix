{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ./common.nix ];

  # User-specific color scheme
  colorScheme = inputs.nix-colors.colorSchemes.hardcore;
  stylix.base16Scheme.base00 = "141414";

  # User identity
  home.username = "mrfluffy";
  home.homeDirectory = "/home/mrfluffy";

  # User-specific GTK theme
  gtk.gtk3 = {
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
