{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          exec-once = [
            "waybar"
            "systemctl --user restart xdg-desktop-portal"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "(hypridle &) && loginctl unlock-session"
            "hyprpaper"
            "foot -s"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "hyprctl setcursor oreo_spark_pink_cursors 16"
            "fcitx5 -d"
          ];
          monitor = [
            "HDMI-A-1,1920x1080@60,0x0,1"
            "DP-1,2560x1440@144,1920x0,1"
          ];
          misc = {
            disable_hyprland_logo = true;
            enable_swallow = true;
            swallow_regex = "footclient";
            #no_direct_scanout = false;
            vfr = false;
          };
          workspace = [
            "HDMI-A-2,10"
            "workspace=DP-1,1"
            "workspace=DP-1,2"
            "workspace=DP-1,3"
            "workspace=DP-1,4"
            "workspace=DP-1,5"
            "workspace=DP-1,6"
            "workspace=DP-1,7"
            "workspace=DP-1,8"
            "workspace=DP-1,9"

          ];
          input = {
            numlock_by_default = true;
            follow_mouse = 1;
            repeat_delay = 300;
            repeat_rate = 50;

            touchpad = {
              natural_scroll = "no";
            };
          };
          general = {
            #sensitivity = 1.0; # for mouse cursor
            gaps_in = 5;
            gaps_out = 5;
            border_size = 2;
            layout = "master";
            #apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
            allow_tearing = true;
          };
          decoration = {
            #blur_ignore_opacity     =   true
            #blur_new_optimizations = true
            rounding = 10;
            #blur=1
            #blur_size=5 # minimum 1
            #blur_passes=1 # minimum 1, more passes = more resource intensive.
            # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
            # if you want heavy blur, you need to up the blur_passes.
            # the more passes, the more you can up the blur_size without noticing artifacts.
          };
          animations = {
            enabled = 1;
            animation = [
              "windows,1,7,default,popin 80%"
              "border,1,7,default"
              "fade,1,7,default"
              "workspaces,1,6,default"
            ];
          };
          master = {
            new_status = "master";
          };
          dwindle = {
            pseudotile = 0; # enable pseudotiling on dwindle
            force_split = 2;
          };
          windowrule = [
            "fullscreen,mpv"
            "float,qalculate-gtk"
            "float,imv"
            "float,scrcpy"
            "float,title:^(whisper)$"
            "size 412 876, scrcpy"
            "center, scrcpy"
            "immediate, title:^(DOOMEternal)$"
            "float, Rofi"
            "float,title:^(kami)$"
            "float,title:^(Open files)$"
            "size 1011 781,title:^(kami)$"
            "move 724 358,title:^(kami)$"
            "stayfocused,title:^(rofi - drun)$"
            #"forceinput,title:^(rofi - drun)$"
            "move cursor -50% -50%,^title:^(rofi - drun)$"
            "tile,WebApp-ytmusic4224"
            "tile,WebApp-discord5149"
          ];
          windowrulev2 = [
            "stayfocused, title:^()$,class:^(steam)$"
            "minsize 1 1, title:^()$,class:^(steam)$"
          ];
          bindm = [
            "ALT,mouse:272, movewindow"
            "ALT,mouse:273, resizewindow"
          ];
          bind = [
            "ALT,Return, exec, footclient"
            "ALT,a,exec,~/repos/Mangayomi-v0.0.7-linux.AppImage"
            "ALT,q,killactive"
            "ALT,f,exec,pcmanfm"
            "ALT,b,exec,zen-twilight"
            "ALT,e,exec,emacs"
            ",107,exec,~/.config/script/wayscreenshot.sh"
            "ALT,p,exec,hyprpicker -f hex | wl-copy"
            "ALT,z,exec,~/.config/hypr/monitors.sh"
            "SHIFT,107,exec,grim -g \"$(slurp)\" - | wl-copy"
            "ALTSHIFT,q, exit,"
            "ALTSHIFT,f, togglefloating,"
            "ALTSHIFT,t, fullscreen, 0"
            "ALT,d, exec, anyrun"
            "ALT,s, exec, foot -T whisper ~/.config/script/wisper.sh"
            "SUPER,w, exec, ~/.config/script/hide_waybar.sh"
            "ALT,h, focusmonitor, DP-2"
            "ALT,l, focusmonitor, DP-3"
            "ALT,k, cyclenext, prev"
            "ALT,j, cyclenext,"
            "ALTSHIFT,h, movewindow, l"
            "ALTSHIFT,l, movewindow, r"
            "ALTSHIFT,k, movewindow, u"
            "ALTSHIFT,j, movewindow, d"
            "ALT,t, togglefloating"
            #"ALT+R submap resize"
            #",l, resizeactive, 30 0"
            #",h, resizeactive, -30 0"
            #",k, resizeactive, 0 -30"
            #",j, resizeactive, 0 30"
            #",escape, submap, reset"
            ",XF86AudioRaiseVolume, exec, pamixer -i 5"
            ",XF86AudioLowerVolume, exec, pamixer -d 5"
            ",XF86AudioMute, exec, pamixer --toggle-mute"
            ",XF86AudioMedia, exec, playerctl play-pause"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPrev, exec, playerctl previous"
            ",XF86AudioNext, exec, playerctl next"
            "ALT,1, workspace, 1"
            "ALT,2, workspace, 2"
            "ALT,3, workspace, 3"
            "ALT,4, workspace, 4"
            "ALT,5, workspace, 5"
            "ALT,6, workspace, 6"
            "ALT,7, workspace, 7"
            "ALT,8, workspace, 8"
            "ALT,9, workspace, 9"
            "ALT,0, workspace, 10"
            "ALT,51, togglespecialworkspace"
            "ALTSHIFT,1, movetoworkspacesilent, 1"
            "ALTSHIFT,2, movetoworkspacesilent, 2"
            "ALTSHIFT,3, movetoworkspacesilent, 3"
            "ALTSHIFT,4, movetoworkspacesilent, 4"
            "ALTSHIFT,5, movetoworkspacesilent, 5"
            "ALTSHIFT,6, movetoworkspacesilent, 6"
            "ALTSHIFT,7, movetoworkspacesilent, 7"
            "ALTSHIFT,8, movetoworkspacesilent, 8"
            "ALTSHIFT,9, movetoworkspacesilent, 9"
            "ALTSHIFT,0, movetoworkspacesilent, 10"
            "ALT,48, movetoworkspace, special"
            "SUPER,mouse_down, workspace, e+1"
            "SUPER,mouse_up, workspace, e-1"
            "ALT,49, togglegroup"
            "ALT,tab, changegroupactive"
          ];
        };
        extraConfig = ''
          # resize Mode with Alt + R : Press Escape to quit
          bind=ALT,R,submap,resize # will switch to a submap called resize
          submap=resize # will start a submap called "resize"

          bind=,l,resizeactive,30 0
          bind=,h,resizeactive,-30 0
          bind=,k,resizeactive,0 -30
          bind=,j,resizeactive,0 30

          bind=,escape,submap,reset # use reset to go back to the global submap
          submap=reset # will reset the submap, meaning end the current one and return to the global one.
        '';
      };
    };
  };
}
