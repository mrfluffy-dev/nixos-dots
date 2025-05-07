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
      };
      colors = {
        alpha = lib.mkForce (0.9);
      };
    };
  };
}

