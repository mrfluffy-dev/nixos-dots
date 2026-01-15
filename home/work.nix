{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ./common.nix ];

  # User-specific color scheme (different from mrfluffy)
  colorScheme = inputs.nix-colors.colorSchemes.blueish;
  stylix.base16Scheme.base00 = "0F1417";

  # User identity
  home.username = "work";
  home.homeDirectory = "/home/work";
}
