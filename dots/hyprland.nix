{
  config,
  lib,
  pkgs,
  window_manager,
  systemName,
  inputs,
  ...
}:
let
  caelestia-cli = inputs.caelestia-cli.packages.${pkgs.system}.caelestia-cli;
  mod = "Alt";
  terminal = "footclient";
  fileManager = "dolphin";
  runner = "${lib.getExe caelestia-cli} shell drawers toggle launcher";
  #runner = "anyrun";
  browser = "zen-beta";
  editor = "emacsclient -c";
in
{
  wayland = {
    windowManager = {
      hyprland = {
        enable = window_manager == "hyprland" || window_manager == "all";
        plugins = [
          pkgs.hyprlandPlugins.hyprsplit
          pkgs.hyprlandPlugins.hyprscrolling
        ];
        settings = {

          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = lib.mkMerge [
            (lib.mkIf (systemName == "laptop") [ "eDP-1,1920x1080@59.99700,0x0,1" ])
            (lib.mkIf (systemName == "pc") [
              "HDMI-A-2,1920x1080@60,0x0,1"
              "DP-1,2560x1440@144,1920x0,1"
              #"DP-1,2560x1440@144,1920x0,1,bitdepth,10,cm,hdr"
            ])
          ];
          # Autostart necessary processes (like notifications daemons, status bars, etc.)
          # Or execute your favorite apps at launch like this:
          exec-once = [
            #"waybar"
            #"quickshell"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "fcitx5 -d"
            "foot -s"
            "systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP QT_QPA_PLATFORMTHEME GTK_THEME"
            "dbus-update-activation-environment --systemd --all"
          ]
          ++ lib.optionals (config.home.username == "work") [
            "thunderbird"
            "sleep 10 && emacsclient -c --frame-parameters='((name . \"work\"))' $HOME/Documents/work/README.org"
          ];
          #++ lib.optional (systemName == "laptop") "swaybg -o eDP-1 -i ${../assets/Wallpapers/138.png}"
          #++
          #  lib.optional (systemName == "pc")
          #    "swaybg -o HDMI-A-1 -i ${../assets/Wallpapers/138.png} -o DP-1 -i ${../assets/Wallpapers/138.png}";

          #plugins
          plugin = {
            hyprsplit = {
              num_workspaces = 10;
              persistent_workspaces = true;
            };
            hyprscrolling = {
              fullscreen_on_one_column = false;
              column_width = 0.7;
              explicit_column_widths = [
                0.333
                0.5
                0.667
                1.0
              ];
              focus_fit_method = 0;
            };
          };

          env = [
            "XCURSOR_SIZE, 24"
            "HYPRCURSOR_SIZE, 24"
          ];
          # Refer to https://wiki.hyprland.org/Configuring/Variables/
          # https://wiki.hyprland.org/Configuring/Variables/#general
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            #"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            #"col.inactive_border" = "rgba(595959aa)";
            # Set to true enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false;
            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
            layout = "dwindle";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration = {
            rounding = 10;
            rounding_power = 2;
            # Change transparency of focused and unfocused windows
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              #color = "rgba(1a1a1aee)";
            };
            # https://wiki.hyprland.org/Configuring/Variables/#blur
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };
          animations = {
            enabled = "yes, please :)";
            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };
          # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
          # "Smart gaps" / "No gaps when only"
          # uncomment all if you wish to use that.
          # workspace = w[tv1], gapsout:0, gapsin:0
          # workspace = f[1], gapsout:0, gapsin:0
          # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
          # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
          # windowrule = bordersize 0, floating:0, onworkspace:f[1]
          # windowrule = rounding 0, floating:0, onworkspace:f[1]

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle = {
            pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # You probably want this
            force_split = 2;
          };

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master = {
            new_status = "master";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc = {
            force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
            enable_swallow = true;
            swallow_regex = "foot";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input = {
            kb_layout = lib.mkMerge [
              (lib.mkIf (systemName == "laptop") "ie")
              (lib.mkIf (systemName == "pc") "us")
            ];
            repeat_rate = 40;
            repeat_delay = 500;
            #kb_variant =
            #kb_model =
            #kb_options =
            #kb_rules =
            follow_mouse = 1;
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            touchpad = {
              natural_scroll = false;
            };
          };
          # https://wiki.hyprland.org/Configuring/Variables/#gestures
          #gestures = {
          #  workspace_swipe = true;
          #  workspace_swipe_cancel_ratio = 0.15;
          #};

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device = {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          };

          bind = [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "${mod}, Return, exec, ${terminal}"
            "${mod}, B, exec, ${browser}"
            "${mod}, Q, killactive,"
            "${mod}, M, exit,"
            "${mod}, F, exec, ${fileManager}"
            "${mod}, V, togglefloating,"
            "${mod}, T, fullscreen"
            "${mod}, D, exec, ${runner}"
            "${mod}, E, exec, ${editor}"
            #",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
            ",Print, exec, ${lib.getExe caelestia-cli} screenshot -r -f"
            "${mod}, P, pseudo, " # dwindle
            #focus with mainMod + arrow keys
            #"${mod}, H, movefocus, l"
            #"${mod}, L, movefocus, r"
            "${mod}, K, movefocus, u"
            "${mod}, J, movefocus, d"
            "${mod} SHIFT, H, movewindow, l"
            "${mod}, h, layoutmsg, move -col"
            "${mod} SHIFT, L, movewindow, r"
            "${mod}, L, layoutmsg, move +col"
            "${mod} SHIFT, K, movewindow, u"
            "${mod} SHIFT, J, movewindow, d"

            # Switch workspaces with Mod + [0-9]
            "${mod}, 1, split:workspace, 1 "
            "${mod}, 2, split:workspace, 2 "
            "${mod}, 3, split:workspace, 3 "
            "${mod}, 4, split:workspace, 4 "
            "${mod}, 5, split:workspace, 5 "
            "${mod}, 6, split:workspace, 6 "
            "${mod}, 7, split:workspace, 7 "
            "${mod}, 8, split:workspace, 8 "
            "${mod}, 9, split:workspace, 9 "
            "${mod}, 0, split:workspace, 10"
            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "${mod} SHIFT, 1, split:movetoworkspacesilent, 1 "
            "${mod} SHIFT, 2, split:movetoworkspacesilent, 2 "
            "${mod} SHIFT, 3, split:movetoworkspacesilent, 3 "
            "${mod} SHIFT, 4, split:movetoworkspacesilent, 4 "
            "${mod} SHIFT, 5, split:movetoworkspacesilent, 5 "
            "${mod} SHIFT, 6, split:movetoworkspacesilent, 6 "
            "${mod} SHIFT, 7, split:movetoworkspacesilent, 7 "
            "${mod} SHIFT, 8, split:movetoworkspacesilent, 8 "
            "${mod} SHIFT, 9, split:movetoworkspacesilent, 9 "
            "${mod} SHIFT, 0, split:movetoworkspacesilent, 10"
            # Example special workspace (scratchpad)
            "${mod}, SLASH, togglespecialworkspace, magic"
            "${mod} SHIFT, SLASH, movetoworkspace, special:magic"
            # Scroll through existing workspaces with mainMod + scroll
            "${mod}, mouse_down, workspace, e+1"
            "${mod}, mouse_up, workspace, e-1"
            # 8BitDo keyboard big red b Button
            "${mod} SHIFT, F1, exec, scrcpy --video-source=camera -m3000 --camera-facing=back --v4l2-sink=/dev/video1 --no-video-playback --no-audio"

          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "${mod}, mouse:272, movewindow"
            "${mod}, mouse:273, resizewindow"
          ];

          bindel = [
            ",XF86AudioRaiseVolume, exec, pamixer -i 5"
            ",XF86AudioLowerVolume, exec, pamixer -d 5"
            ",XF86AudioMute, exec, pamixer --toggle-mute"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            #",XF86MonBrightnessUp, exec, light -A 5"
            #",XF86MonBrightnessDown, exec, light -U 5"

            # Brightness
            ",XF86MonBrightnessUp, global, caelestia:brightnessUp"
            ",XF86MonBrightnessDown, global, caelestia:brightnessDown"
          ];
          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause "
            ", XF86AudioPrev, exec, playerctl previous   "
          ];
          binds = [

          ];

          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

          # Example windowrule
          # windowrule = float,class:^(kitty)$,title:^(kitty)$

          # Ignore maximize requests from apps. You'll probably like this.
          windowrule = [
            # Ignore maximize requests from apps. You'll probably like this.
            "suppressevent maximize, class:.*"
            # Fix some dragging issues with XWayland
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
            "workspace special:magic silent, class:thunderbird"
            "workspace special:magic silent, class:emacs, title:work"
          ];

        };
      };
    };
  };
}
