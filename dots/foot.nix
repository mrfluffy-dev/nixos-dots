{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "5x5";
        include="/home/${config.home.username}/.config/foot/dank-colors.ini";
      };
      colors = {
        alpha = lib.mkForce (0.9);
      };
    };
  };
}

