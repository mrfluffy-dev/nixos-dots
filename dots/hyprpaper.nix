{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.hyprpaper = {
    enable = false;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${../assets/Wallpapers/138.png}"
        "${../assets/Wallpapers/138.png}"
      ];

      wallpaper = [
        "DP-1,${../assets/Wallpapers/138.png}"
        "HDMI-A-1,${../assets/Wallpapers/138.png}"
      ];
    };
  };
}
