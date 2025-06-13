{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    niri = {
      settings = {
        outputs."eDP-1".scale = 1.0;
        spawn-at-startup = [
          {
            command = [ "xwayland-satellite" ];
          }
        ];
        environment = {
          DISPLAY = ":0";
        };
        binds = {
          "Mod+T".action.spawn = "alacritty";
        };
      };
    };
  };
}
