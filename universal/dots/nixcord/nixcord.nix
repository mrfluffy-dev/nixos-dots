{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nixcord = {
    enable = true;
    discord.vencord.enable = false;
    discord.vencord.package = pkgs.vencord;

  };
}
