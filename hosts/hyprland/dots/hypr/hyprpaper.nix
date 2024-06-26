{ pkgs, config, ... }:

{
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
preload = ~/Pictures/Wallpapers/133.png
#if more than one preload is desired then continue to preload other backgrounds
preload = ~/Pictures/Wallpapers/138.png
# .. more preloads


#set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
wallpaper = DP-1,~/Pictures/Wallpapers/133.png
#if more than one monitor in use, can load a 2nd image
wallpaper = HDMI-A-2,~/Pictures/Wallpapers/138.png
# .. more monitors
#

#enable splash text rendering over the wallpaper
# splash = true

#fully disable ipc
# ipc = off
      '';
    };
}
