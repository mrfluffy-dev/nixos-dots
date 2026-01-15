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
  home.username = "game";
  home.homeDirectory = "/home/game";
}
