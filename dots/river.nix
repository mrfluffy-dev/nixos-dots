{
  pkgs,
  lib,
  config,
  window_manager,
  systemName,
  ...
}:
{
  wayland.windowManager.river = {
    enable = window_manager == "river" || window_manager == "all";
    xwayland.enable = true;
    extraConfig = ''
      #!/bin/sh
      #
      #
      #systemctl --user import-environment
      #
      #
      #eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
      #export SSH_AUTH_SOCK
      browser="zen-twilight"
      file_manager="pcmanfm"
      terminal="footclient"
      drunner="anyrun"
      editor="emacs"

      riverctl input "pointer-2362-8197-ASUP1204:00_093A:2005_Touchpad" tap enabled
      riverctl keyboard-layout  -options "grp:ctrl_space_toggle" ${
        if systemName == "laptop" then "ie,us" else "us"
      }

      #riverctl spawn 'export XDG_CURRENT_DESKTOP=river'
      #riverctl spawn 'systemctl --user restart xdg-desktop-portal'
      riverctl spawn 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'
      riverctl spawn 'swaybg ${
        # Handle laptop case
        lib.optionalString (systemName == "laptop") "-o eDP-1 -i ${../assets/Wallpapers/138.png}"
      }${
        # Handle PC case (appends to laptop case if needed, but conditions should be mutually exclusive)
        lib.optionalString (
          systemName == "pc"
        ) "-o HDMI-A-1 -i ${../assets/Wallpapers/138.png} -o DP-1 -i ${../assets/Wallpapers/138.png}"
      }'
      #riverctl spawn '/home/mrfluffy/.config/script/mic-gain-fix.sh'
      riverctl spawn 'waybar &'
      #riverctl spawn '(hypridle &) && loginctl unlock-session'
      #riverctl spawn '(sleep 10 && systemctl --user restart hypridle.service) &'
      #riverctl spawn '/nix/store/$(ls -la /nix/store | grep "polkit-gnome" | grep "^d" | awk ""$0=$NF" | head -n 1)/libexec/polkit-gnome-authentication-agent-1'
      riverctl spawn ' ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1'
      riverctl spawn '/home/mrfluffy/.config/script/waylock.sh'
      riverctl spawn 'fcitx5 -d'
      riverctl spawn 'foot -s'
      riverctl spawn '[ -n "$(whereis swaync | awk '{print $2}')" ] && swaync'
      riverctl spawn 'nm-applet'
      riverctl focus-follows-cursor normal
      riverctl set-cursor-warp on-focus-change
      #riverctl xcursor-theme oreo_spark_pink_cursors
      riverctl spawn '${
        # Handle laptop case
        lib.optionalString (systemName == "laptop") "wlr-randr --output eDP-1 --mode 1920x1080@60"
      }${
        # Handle PC case (appends to laptop case if needed, but conditions should be mutually exclusive)
        lib.optionalString (systemName == "pc")
          "wlr-randr --output DP-1 --mode 2560x1440@144 --pos 1920,0 --output HDMI-A-1 --mode 1920x1080@60 --pos 0,0"
      }'

      # This is the example configuration file for river.
      #
      # If you wish to edit this, you will probably want to copy it to
      # $XDG_CONFIG_HOME/river/init or $HOME/.config/river/init first.
      #
      # See the river(1), riverctl(1), and rivertile(1) man pages for complete
      # documentation.

      # Note: the "Mod4" modifier is also known as Logo, GUI, Windows, Mod4, etc.
      #
      riverctl map normal Mod1+Shift+Control L spawn way-inhibitor

      # Mod4+Shift+Return to start an instance of foot (https://codeberg.org/dnkl/foot)
      riverctl map normal Mod1 Return spawn $terminal

      # Mod4+D open wofi
      riverctl map normal Mod1 D spawn $drunner

      #Mod4+b open browser
      riverctl map normal Mod1 B spawn $browser

      #Mod1+F open file manager
      riverctl map normal Mod1 F spawn $file_manager

      #mod1+e open emacs
      riverctl map normal Mod1 E spawn $editor

      # Mod4+Q to close the focused view
      riverctl map normal Mod1 Q close

      # Mod4+Shift+E to exit river
      riverctl map normal Mod1+Shift Q exit

      # Mod4+J and Super+K to focus the next/previous view in the layout stack
      riverctl map normal Mod1 J focus-view next
      riverctl map normal Mod1 K focus-view previous

      # Mod4+Shift+J and Super+Shift+K to swap the focused view with the next/previous
      # view in the layout stack
      riverctl map normal Mod1+Shift J swap next
      riverctl map normal Mod1+Shift K swap previous

      # Mod4+Period and Super+Comma to focus the next/previous output
      riverctl map normal Mod1 L focus-output next
      riverctl map normal Mod1 H focus-output previous

      # Mod4+Shift+{Period,Comma} to send the focused view to the next/previous output
      riverctl map normal Mod1+Shift L send-to-output next
      riverctl map normal Mod1+Shift H send-to-output previous

      # Mod4+Return to bump the focused view to the top of the layout stack
      riverctl map normal Mod4 Return zoom

      # Mod4+H and Super+L to decrease/increase the main ratio of rivertile(1)
      riverctl map normal Mod1+Control H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Mod1+Control L send-layout-cmd rivertile "main-ratio +0.05"

      # Mod4+Mod1+{H,J,K,L} to move views
      riverctl map normal Mod4+Mod1 H move left 100
      riverctl map normal Mod4+Mod1 J move down 100
      riverctl map normal Mod4+Mod1 K move up 100
      riverctl map normal Mod4+Mod1 L move right 100

      # Mod4+Mod1+Control+{H,J,K,L} to snap views to screen edges
      riverctl map normal Mod4+Mod1+Control H snap left
      riverctl map normal Mod4+Mod1+Control J snap down
      riverctl map normal Mod4+Mod1+Control K snap up
      riverctl map normal Mod4+Mod1+Control L snap right

      # Mod4+Mod1+Shif+{H,J,K,L} to resize views
      riverctl map normal Mod4+Mod1+Shift H resize horizontal -100
      riverctl map normal Mod4+Mod1+Shift J resize vertical 100
      riverctl map normal Mod4+Mod1+Shift K resize vertical -100
      riverctl map normal Mod4+Mod1+Shift L resize horizontal 100

      # Mod4 + Left Mouse Button to move views
      riverctl map-pointer normal Alt BTN_LEFT move-view

      # Mod4 + Right Mouse Button to resize views
      riverctl map-pointer normal Alt BTN_RIGHT resize-view

      for i in $(seq 1 9); do
          tags=$((1 << ($i - 1)))

          # Mod4+[1-9] to focus tag [0-8]
          riverctl map normal Mod1 $i set-focused-tags $tags

          # Mod4+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Mod1+Shift $i set-view-tags $tags

          # Mod4+Ctrl+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Mod1+Control $i toggle-focused-tags $tags

          # Mod4+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Mod1+Shift+Control $i toggle-view-tags $tags
      done

      # Mod4+0 to focus all tags
      # Mod4+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Mod4 0 set-focused-tags $all_tags
      riverctl map normal Mod4+Shift 0 set-view-tags $all_tags

      # Mod4+Space to toggle float
      riverctl map normal Mod1 Space toggle-float

      # Mod4+F to toggle fullscreen
      riverctl map normal Mod1 t toggle-fullscreen

      # Mod4+{Up,Right,Down,Left} to change layout orientation
      riverctl map normal Mod4 Up send-layout-cmd rivertile "main-location top"
      riverctl map normal Mod4 Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Mod4 Down send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Mod4 Left send-layout-cmd rivertile "main-location left"

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      riverctl declare-mode passthrough

      # Mod4+F11 to enter passthrough mode
      riverctl map normal Mod4 F11 enter-mode passthrough

      # Mod4+F11 to return to normal mode
      riverctl map passthrough Mod4 F11 enter-mode normal

      # Various media key mapping examples for both normal and locked mode which do
      # not have a modifier
      for mode in normal locked; do
          # Eject the optical drive (well if you still have one that is)
          riverctl map $mode None XF86Eject spawn 'eject -T'

          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume spawn 'pamixer -i 5'
          riverctl map $mode None XF86AudioLowerVolume spawn 'pamixer -d 5'
          riverctl map $mode None XF86AudioMute spawn 'pamixer --toggle-mute'

          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext spawn 'playerctl next'
          #print screen
          riverctl map $mode None Print spawn 'grim -g "$(slurp)" - | swappy -f -'
          # Control screen backlight brighness with light (https://github.com/haikarainen/light)
          riverctl map $mode None XF86MonBrightnessUp spawn 'light -A 5'
          riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
      done

      #make a raw mode
      riverctl declare-mode raw
      riverctl map normal Mod1 r spawn 'riverctl enter-mode raw'
      riverctl map raw Mod1 r spawn 'riverctl enter-mode normal'



      # Set background and border color
      #riverctl background-color 0x002b36
      #riverctl border-color-focused 0x8218c4
      #riverctl border-color-unfocused 0xff282a36
      #riverctl border-width 3

      #set ssd for apps
      riverctl rule-add ssd

      # Set keyboard repeat rate
      riverctl set-repeat 50 300

      # Make certain views start floating
      riverctl float-filter-add app-id float
      riverctl float-filter-add title "popup title with spaces"
      riverctl rule-add -title "Idle Inhibitor" float
      # Set app-ids and titles of views which should use client side decorations
      riverctl csd-filter-add app-id "gedit"

      # Set and exec into the default layout generator, rivertile.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      exec rivertile -view-padding 3 -outer-padding 3 -main-ratio 0.5

    '';

  };
}
