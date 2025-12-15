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
  caelestia-cli = inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-cli;
  hypr-package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hypr-portal = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  hypr-split = inputs.hyprland-hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces;
  #hyprscrolling = inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling;
  mod = "Alt";
  terminal = "footclient";
  fileManager = "thunar";
  #runner = "${lib.getExe caelestia-cli} shell drawers toggle launcher";
  runner = "vicinae toggle";
  # runner     = "anyrun";
  browser = "zen-beta";
  editor = "emacsclient -c";
in
{
  wayland.windowManager.hyprland = {
    enable = window_manager == "hyprland" || window_manager == "all";
    package = hypr-package;
    portalPackage = hypr-portal;
    plugins = [
      #pkgs.hyprlandPlugins.hyprsplit
      hypr-split
      #hyprscrolling
    ];

    settings = {
      ##########################################################################
      # Monitors
      ##########################################################################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = lib.mkMerge [
        #(lib.mkIf (systemName == "laptop") [ "eDP-1,1920x1080@59.99700,0x0,1" ])
        (lib.mkIf (systemName == "pc") [
          "HDMI-A-2, disable"
        ])
      ];

      monitorv2 =
        [ ]
        ++ lib.optional (systemName == "laptop") {
          output = "eDP-1";
          mode = "1920x1080@59.99700";
          scale = 1;
          position = "0x0";
        }
        ++ lib.optional (systemName == "pc") {
          output = "DP-1";
          mode = "2560x1440@239.97";
          position = "2560x0"; # "1440x750";  # Corrected from 2569x0 for seamless alignment
          scale = 1;
          #supports_wide_color = 1;
          bitdepth = 10;
          cm = "hdr";
          supports_hdr = true;
          supports_wide_color = true;
          sdr_min_luminance = 0; # For true black on OLED
          sdr_max_luminance = 275; # Matches typical SDR brightness
          min_luminance = 0;
          max_luminance = 1000; # HDR peak
          max_avg_luminance = 400; # Average frame luminance
          sdrbrightness = 1.2; # Slight boost to avoid washed out look
          sdrsaturation = 1.0;
          #transform          = 2;    # Uncomment if needed
        }
        ++ lib.optional (systemName == "pc") {
          output = "DP-2";
          mode = "2560x1440@144";
          scale = 1;
          position = "0x0";
          transform = 0;
        };

      ##########################################################################
      # Autostart
      ##########################################################################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:
      exec-once = [
        # "waybar"
        # "quickshell"
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
      # ++ lib.optional (systemName == "laptop")
      #   "swaybg -o eDP-1 -i ${../assets/Wallpapers/138.png}"
      #
      # ++ lib.optional (systemName == "pc")
      #   "swaybg -o HDMI-A-1 -i ${../assets/Wallpapers/138.png} -o DP-1 -i ${../assets/Wallpapers/138.png}";

      ##########################################################################
      # Plugins
      ##########################################################################

      plugin = {
        split-monitor-workspaces = {
          count = 10;
          penable_persistent_workspaces = 1;
        };
        hyprscrolling = {
          column_width = 0.9;
          follow_focus = false;
          fullscreen_on_one_column = true;
        };
      };

      ##########################################################################
      # Environment
      ##########################################################################

      env = [
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_SIZE, 24"
      ];

      ##########################################################################
      # General / Render / Decoration / Animations
      ##########################################################################

      # https://wiki.hyprland.org/Configuring/Variables/
      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # "col.active_border"   = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false; # enable resizing windows by clicking and dragging on borders and gaps
        allow_tearing = false; # see https://wiki.hyprland.org/Configuring/Tearing/ before enabling
        layout = "master";
      };

      render = {
        cm_enabled = true; # turn on the CM pipeline (requires Hyprland restart)
        cm_fs_passthrough = 2; # passthrough only for HDR content (safer than 1)
        cm_auto_hdr = 1; # auto-switch monitor to HDR for fullscreen apps
        send_content_type = true; # helps auto HDR on some displays
        # cm_fs_passthrough = 1;    # optional: keep your existing line; you can replace with 2 as above
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          # color      = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = false;
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

      ##########################################################################
      # Layouts
      ##########################################################################

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds
        preserve_split = true; # You probably want this
        force_split = 2;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
        mfact = 0.5;
        new_on_top = true;
      };

      ##########################################################################
      # Misc / Input / Gestures / Devices
      ##########################################################################

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        enable_swallow = true;
        swallow_regex = "footclient";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = lib.mkMerge [
          (lib.mkIf (systemName == "laptop") "ie")
          (lib.mkIf (systemName == "pc") "us")
        ];
        repeat_rate = 40;
        repeat_delay = 500;
        # kb_variant  =
        # kb_model    =
        # kb_options  =
        # kb_rules    =
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = false;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      # gestures = {
      #   workspace_swipe = true;
      #   workspace_swipe_cancel_ratio = 0.15;
      # };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      ##########################################################################
      # Binds
      ##########################################################################

      bind = [
        # Launcher / apps
        "${mod}, Return, exec, ${terminal}"
        "${mod}, B, exec, ${browser}"
        "${mod}, F, exec, ${fileManager}"
        "${mod}, D, exec, ${runner}"
        "${mod}, E, exec, ${editor}"

        # Session / window controls
        "${mod}, Q, killactive,"
        "${mod}, M, exit,"
        "${mod}, V, togglefloating,"
        "${mod}, T, fullscreen"
        # ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        ",Print, exec, ${lib.getExe caelestia-cli} screenshot -r -f"

        # Dwindle
        "${mod}, P, pseudo, "

        # Focus (arrows)
        "${mod}, H, movefocus, l"
        "${mod}, L, movefocus, r"
        "${mod}, K, movefocus, u"
        "${mod}, J, movefocus, d"

        # Column movement (hyprscrolling)
        #"${mod}, h, layoutmsg, move -col"
        #"${mod}, L, layoutmsg, move +col"

        # Move window
        "${mod} SHIFT, H, movewindow, l"
        "${mod} SHIFT, L, movewindow, r"
        "${mod} SHIFT, K, movewindow, u"
        "${mod} SHIFT, J, movewindow, d"
        #"${mod} SHIFT, L, layoutmsg, movewindowto r"
        #"${mod} SHIFT, H, layoutmsg, movewindowto l"
        #"${mod} SHIFT, K, layoutmsg, movewindowto u"
        #"${mod} SHIFT, J, layoutmsg, movewindowto d"
        "${mod}, semicolon, layoutmsg, promote"

        #hyperscrolling stuff
        "${mod}, period, layoutmsg, move +col"
        "${mod}, comma, layoutmsg, move -col"

        # Workspaces (switch)
        "${mod}, 1, split-workspace, 1 "
        "${mod}, 2, split-workspace, 2 "
        "${mod}, 3, split-workspace, 3 "
        "${mod}, 4, split-workspace, 4 "
        "${mod}, 5, split-workspace, 5 "
        "${mod}, 6, split-workspace, 6 "
        "${mod}, 7, split-workspace, 7 "
        "${mod}, 8, split-workspace, 8 "
        "${mod}, 9, split-workspace, 9 "
        "${mod}, 0, split-workspace, 10"

        # Workspaces (move active window)
        "${mod} SHIFT, 1, split-movetoworkspacesilent, 1 "
        "${mod} SHIFT, 2, split-movetoworkspacesilent, 2 "
        "${mod} SHIFT, 3, split-movetoworkspacesilent, 3 "
        "${mod} SHIFT, 4, split-movetoworkspacesilent, 4 "
        "${mod} SHIFT, 5, split-movetoworkspacesilent, 5 "
        "${mod} SHIFT, 6, split-movetoworkspacesilent, 6 "
        "${mod} SHIFT, 7, split-movetoworkspacesilent, 7 "
        "${mod} SHIFT, 8, split-movetoworkspacesilent, 8 "
        "${mod} SHIFT, 9, split-movetoworkspacesilent, 9 "
        "${mod} SHIFT, 0, split-movetoworkspacesilent, 10"

        # Special workspace (scratchpad)
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
        # ",XF86MonBrightnessUp, exec, light -A 5"
        # ",XF86MonBrightnessDown, exec, light -U 5"

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

      binds = [ ];

      ##########################################################################
      # Rules (windows / workspaces)
      ##########################################################################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule
      # windowrule = float,class:^(kitty)$,title:^(kitty)$

      # Smart gaps / No gaps when only
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrule = bordersize 0, floating:0, onworkspace:f[1]
      # windowrule = rounding 0, floating:0, onworkspace:f[1]

      windowrule = [
        # Ignore maximize requests from apps. You'll probably like this.
        "match:class .*, suppress_event maximize"

        # Fix some dragging issues with XWayland
        "match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0, no_focus on"

        "match:class thunderbird, workspace special:magic silent"
        "match:class emacs, match:title work, workspace special:magic silent"
      ];
    };
  };
}
