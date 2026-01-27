{
  lib,
  pkgs,
  window_manager,
  systemName,
  ...
}:

let
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";

  # Match hyprland definitions
  mod = "Alt";
  terminal = "footclient";
  fileManager = "thunar";
  runner = "dms ipc call spotlight toggle";
  browser = "firefox";
  editor = "emacsclient -c";
in
{
  programs.niri = {
    enable = window_manager == "niri" || window_manager == "all";

    settings = {
      # Input configuration (aligned with hyprland)
      input = {
        keyboard = {
          xkb.layout = lib.mkMerge [
            (lib.mkIf isLaptop "ie")
            (lib.mkIf isPc "us")
          ];
          repeat-rate = 40;
          repeat-delay = 500;
        };

        touchpad = {
          tap = true;
          natural-scroll = false; # Match hyprland
          dwt = true;
        };

        mouse = {
          accel-profile = "flat";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%"; # Don't scroll/center on hover, only on click
        };
      };

      # Layout settings (aligned with hyprland gaps)
      layout = {
        gaps = 10; # hyprland: gaps_out = 10
        center-focused-column = "always";

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 0.9; }
        ];

        default-column-width = { proportion = 0.95; };

        focus-ring = {
          enable = true; # Hyprland doesn't have separate focus ring
        };

        border = {
          enable = true;
        };

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
          color = "#00000070";
        };
      };

      # Startup programs (aligned with hyprland exec-once)
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
        { command = [ "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1" ]; }
        { command = [ "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init" ]; }
        { command = [ "fcitx5" "-d" ]; }
        { command = [ "foot" "-s" ]; }
        { command = [ "sh" "-c" "systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP QT_QPA_PLATFORMTHEME GTK_THEME" ]; }
        { command = [ "dbus-update-activation-environment" "--systemd" "--all" ]; }
      ];

      # Prefer server-side decorations
      prefer-no-csd = true;

      # Screenshot path
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # Environment variables
      environment = {
        DISPLAY = ":0";
      };

      # Hotkey overlay settings
      hotkey-overlay.skip-at-startup = true;

      # Keybinds (aligned with hyprland)
      binds = {
        # App launchers (matching hyprland)
        "${mod}+Return".action.spawn = [ terminal ];
        "${mod}+B".action.spawn = [ browser ];
        "${mod}+F".action.spawn = [ fileManager ];
        "${mod}+D".action.spawn = [ "sh" "-c" runner ];
        "${mod}+E".action.spawn = [ "sh" "-c" editor ];

        # Audio control (using pamixer like hyprland)
        "XF86AudioRaiseVolume".action.spawn = [ "pamixer" "-i" "5" ];
        "XF86AudioLowerVolume".action.spawn = [ "pamixer" "-d" "5" ];
        "XF86AudioMute".action.spawn = [ "pamixer" "--toggle-mute" ];
        "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

        # Media controls (matching hyprland)
        "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
        "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];
        "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
        "XF86AudioPause".action.spawn = [ "playerctl" "play-pause" ];

        # Brightness control
        "XF86MonBrightnessUp".action.spawn = [ "sh" "-c" "dms ipc call brightness increment 5" ];
        "XF86MonBrightnessDown".action.spawn = [ "sh" "-c" "dms ipc call brightness decrement 5" ];

        # Window management (matching hyprland)
        "${mod}+Q".action.close-window = {};
        "${mod}+M".action.quit = {}; # Match hyprland exit
        "${mod}+V".action.toggle-window-floating = {};
        "${mod}+T".action.fullscreen-window = {}; # Match hyprland fullscreen

        # Screenshots (using dms like hyprland)
        "Print".action.spawn = [ "dms" "screenshot" ];
        "${mod}+F1".action.spawn = [ "sh" "-c" "dms ipc call keybinds toggle niri" ];
        "${mod}+Backslash".action.spawn = [ "sh" "-c" "dms ipc call notepad toggle" ];

        # Focus navigation (vim-style, with workspace wraparound for j/k)
        "${mod}+H".action.focus-column-or-monitor-left = {};
        "${mod}+J".action.focus-window-or-workspace-down = {};
        "${mod}+K".action.focus-window-or-workspace-up = {};
        "${mod}+L".action.focus-column-or-monitor-right = {};

        # Move windows (matching hyprland)
        "${mod}+Shift+H".action.move-column-left = {};
        "${mod}+Shift+J".action.move-window-down = {};
        "${mod}+Shift+K".action.move-window-up = {};
        "${mod}+Shift+L".action.move-column-right = {};

        # Monitor focus
        "${mod}+Ctrl+H".action.focus-monitor-left = {};
        "${mod}+Ctrl+J".action.focus-monitor-down = {};
        "${mod}+Ctrl+K".action.focus-monitor-up = {};
        "${mod}+Ctrl+L".action.focus-monitor-right = {};

        # Move to monitor
        "${mod}+Ctrl+Shift+H".action.move-column-to-monitor-left = {};
        "${mod}+Ctrl+Shift+J".action.move-column-to-monitor-down = {};
        "${mod}+Ctrl+Shift+K".action.move-column-to-monitor-up = {};
        "${mod}+Ctrl+Shift+L".action.move-column-to-monitor-right = {};

        # Workspace numbers (matching hyprland)
        "${mod}+1".action.focus-workspace = 1;
        "${mod}+2".action.focus-workspace = 2;
        "${mod}+3".action.focus-workspace = 3;
        "${mod}+4".action.focus-workspace = 4;
        "${mod}+5".action.focus-workspace = 5;
        "${mod}+6".action.focus-workspace = 6;
        "${mod}+7".action.focus-workspace = 7;
        "${mod}+8".action.focus-workspace = 8;
        "${mod}+9".action.focus-workspace = 9;
        "${mod}+0".action.focus-workspace = 10;

        "${mod}+Shift+1".action.move-column-to-workspace = 1;
        "${mod}+Shift+2".action.move-column-to-workspace = 2;
        "${mod}+Shift+3".action.move-column-to-workspace = 3;
        "${mod}+Shift+4".action.move-column-to-workspace = 4;
        "${mod}+Shift+5".action.move-column-to-workspace = 5;
        "${mod}+Shift+6".action.move-column-to-workspace = 6;
        "${mod}+Shift+7".action.move-column-to-workspace = 7;
        "${mod}+Shift+8".action.move-column-to-workspace = 8;
        "${mod}+Shift+9".action.move-column-to-workspace = 9;
        "${mod}+Shift+0".action.move-column-to-workspace = 10;

        # Scroll through workspaces (matching hyprland mouse scroll)
        "${mod}+WheelScrollDown".action.focus-workspace-down = {};
        "${mod}+WheelScrollUp".action.focus-workspace-up = {};

        # Column management (niri-specific, kept similar)
        "${mod}+Comma".action.consume-window-into-column = {};
        "${mod}+Period".action.expel-window-from-column = {};
        "${mod}+BracketLeft".action.consume-or-expel-window-left = {};
        "${mod}+BracketRight".action.consume-or-expel-window-right = {};
        "${mod}+Semicolon".action.focus-column-first = {}; # Similar to promote in master layout

        # Window sizing
        "${mod}+Minus".action.set-column-width = "-10%";
        "${mod}+Equal".action.set-column-width = "+10%";
        "${mod}+Shift+Minus".action.set-window-height = "-10%";
        "${mod}+Shift+Equal".action.set-window-height = "+10%";

        "${mod}+R".action.switch-preset-column-width = {};
        "${mod}+Shift+R".action.switch-preset-window-height = {};
        "${mod}+C".action.center-column = {};

        # Floating
        "${mod}+Shift+V".action.switch-focus-between-floating-and-tiling = {};

        # Tabs
        "${mod}+W".action.toggle-column-tabbed-display = {};

        # Window overview (alt-tab replacement)
        "${mod}+Tab".action.toggle-overview = {};

        # Misc
        "${mod}+Escape".action.toggle-keyboard-shortcuts-inhibit = {};
        "${mod}+Shift+P".action.power-off-monitors = {};
      };

      # Window rules
      window-rules = [
        # Float file dialogs
        {
          matches = [{ title = "^Open File$"; }];
          open-floating = true;
        }
        {
          matches = [{ title = "^Save File$"; }];
          open-floating = true;
        }
      ];
    };
  };

  # Redirect the generated config to a different file
  xdg.configFile.niri-config.target = lib.mkForce "niri/generated.kdl";

  # Create the main config that includes everything
  xdg.configFile."niri/config.kdl".text = ''
    include "generated.kdl"
    include "dms/outputs.kdl"
    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/alttab.kdl"
    include "dms/binds.kdl"
    include "dms/cursor.kdl"
  '';
}
