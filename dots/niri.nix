{
  lib,
  pkgs,
  window_manager,
  systemName,
  ...
}:

let
  isLaptop = systemName == "laptop";
in
{
  programs.niri = {
    enable = window_manager == "niri" || window_manager == "all";

    settings = {
      # Input configuration
      input = {
        keyboard = {
          xkb.layout = "ie";
          numlock = true;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
        };

        mouse = {
          accel-profile = "flat";
        };

        warp-mouse-to-focus.enable = true;
        focus-follows-mouse.enable = true;
      };

      # Layout settings
      layout = {
        gaps = 8;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        default-column-width = { proportion = 1.0 / 2.0; };

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#7fc8ff";
          inactive.color = "#505050";
        };

        border = {
          enable = true;
          width = 2;
          active.color = "#ffc87f";
          inactive.color = "#505050";
        };

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
          color = "#00000070";
        };
      };

      # Startup programs
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
        #{ command = [ "waybar" ]; }
        { command = [ "foot" "--server" ]; }
        #{ command = [ "swaybg" "-i" "${../assets/Wallpapers/138.png}" "-m" "fill" ]; }
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

      # Keybinds
      binds = {
        # App launchers
        "Mod+Return".action.spawn = [ "footclient" ];
        "Mod+D".action.spawn = [ "anyrun" ];
        "Mod+E".action.spawn = [ "dolphin" ];
        "Super+Alt+L".action.spawn = [ "swaylock" ];

        # Audio control
        "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
        "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
        "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

        # Brightness control (laptop)
        "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
        "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];

        # Window management
        "Mod+Q".action.close-window = {};
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};

        # Focus navigation (vim-style)
        "Mod+H".action.focus-column-left = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+L".action.focus-column-right = {};

        # Move windows
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+J".action.move-window-down = {};
        "Mod+Shift+K".action.move-window-up = {};
        "Mod+Shift+L".action.move-column-right = {};

        # Monitor focus
        "Mod+Ctrl+H".action.focus-monitor-left = {};
        "Mod+Ctrl+J".action.focus-monitor-down = {};
        "Mod+Ctrl+K".action.focus-monitor-up = {};
        "Mod+Ctrl+L".action.focus-monitor-right = {};

        # Move to monitor
        "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = {};
        "Mod+Ctrl+Shift+J".action.move-column-to-monitor-down = {};
        "Mod+Ctrl+Shift+K".action.move-column-to-monitor-up = {};
        "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = {};

        # Workspace navigation
        "Mod+U".action.focus-workspace-down = {};
        "Mod+I".action.focus-workspace-up = {};
        "Mod+Shift+U".action.move-column-to-workspace-down = {};
        "Mod+Shift+I".action.move-column-to-workspace-up = {};

        # Workspace numbers
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Column management
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};
        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};

        # Window sizing
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+C".action.center-column = {};

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};

        # Floating
        "Mod+V".action.toggle-window-floating = {};
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

        # Tabs
        "Mod+W".action.toggle-column-tabbed-display = {};

        # Screenshots
        "Print".action.screenshot = {};
        "Ctrl+Print".action.screenshot-screen = {};
        "Alt+Print".action.screenshot-window = {};

        # Misc
        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # Scroll bindings
        "Mod+WheelScrollDown".action.focus-workspace-down = {};
        "Mod+WheelScrollUp".action.focus-workspace-up = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+WheelScrollRight".action.focus-column-right = {};
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
}
