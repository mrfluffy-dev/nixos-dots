{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    niri = {
      #      settings = {
      #        input = {
      #          keyboard = {
      #            xkb = {
      #              # You can set rules, model, layout, variant and options.
      #              # For more information, see xkeyboard-config(7).
      #
      #              # For example:
      #              # layout "us,ru"
      #              # options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
      #            };
      #
      #            # Enable numlock on startup, omitting this setting disables it.
      #            numlock = true;
      #          };
      #
      #          # Next sections include libinput settings.
      #          # Omitting settings disables them, or leaves them at their default values.
      #          # All commented-out settings here are examples, not defaults.
      #          touchpad = {
      #            # off
      #            tap = true;
      #            # dwt
      #            # dwtp
      #            # drag false
      #            # drag-lock
      #            natural-scroll = true;
      #            # accel-speed 0.2
      #            # accel-profile "flat"
      #            # scroll-method "two-finger"
      #            # disabled-on-external-mouse
      #          };
      #
      #          mouse = {
      #            # off
      #            # natural-scroll
      #            # accel-speed 0.2
      #            # accel-profile "flat"
      #            # scroll-method "no-scroll"
      #          };
      #
      #          trackpoint = {
      #            # off
      #            # natural-scroll
      #            # accel-speed 0.2
      #            # accel-profile "flat"
      #            # scroll-method "on-button-down"
      #            # scroll-button 273
      #            # scroll-button-lock
      #            # middle-emulation
      #          };
      #
      #          # Uncomment this to make the mouse warp to the center of newly focused windows.
      #          # warp-mouse-to-focus
      #
      #          # Focus windows and outputs automatically when moving the mouse into them.
      #          # Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
      #          # focus-follows-mouse max-scroll-amount="0%"
      #        };
      #        # You can configure outputs by their name, which you can find
      #        # by running `niri msg outputs` while inside a niri instance.
      #        # The built-in laptop monitor is usually called "eDP-1".
      #        # Find more information on the wiki:
      #        # https://github.com/YaLTeR/niri/wiki/Configuration:-Outputs
      #        # Remember to uncomment the node by removing "/-"!
      #        outputs."eDP-1" = {
      #          # Uncomment this line to disable this output.
      #          # off
      #
      #          # Resolution and, optionally, refresh rate of the output.
      #          # The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
      #          # If the refresh rate is omitted, niri will pick the highest refresh rate
      #          # for the resolution.
      #          # If the mode is omitted altogether or is invalid, niri will pick one automatically.
      #          # Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
      #          mode = {
      #            width = 1920;
      #            height = 1080;
      #            refresh = 60.00;
      #          };
      #
      #          # You can use integer or fractional scale, for example use 1.5 for 150% scale.
      #          scale = 1.0;
      #
      #          # Transform allows to rotate the output counter-clockwise, valid values are:
      #          # normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
      #          # transform = "normal";
      #
      #          # Position of the output in the global coordinate space.
      #          # This affects directional monitor actions like "focus-monitor-left", and cursor movement.
      #          # The cursor can only move between directly adjacent outputs.
      #          # Output scale and rotation has to be taken into account for positioning:
      #          # outputs are sized in logical, or scaled, pixels.
      #          # For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
      #          # so to put another output directly adjacent to it on the right, set its x to 1920.
      #          # If the position is unset or results in an overlap, the output is instead placed
      #          # automatically.
      #          position = {
      #            x = 1280;
      #            y = 0;
      #          };
      #        };
      #
      #        # Settings that influence how windows are positioned and sized.
      #        # Find more information on the wiki:
      #        # https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
      #        layout = {
      #          # Set gaps around windows in logical pixels.
      #          gaps = 16;
      #
      #          # When to center a column when changing focus, options are:
      #          # - "never", default behavior, focusing an off-screen column will keep at the left
      #          #   or right edge of the screen.
      #          # - "always", the focused column will always be centered.
      #          # - "on-overflow", focusing a column will center it if it doesn't fit
      #          #   together with the previously focused column.
      #          center-focused-column = "never";
      #
      #          # You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
      #          preset-column-widths = [
      #            # Proportion sets the width as a fraction of the output width, taking gaps into account.
      #            # For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
      #            # The default preset widths are 1/3, 1/2 and 2/3 of the output.
      #            { proportion = 0.33333; }
      #            { proportion = 0.5; }
      #            { proportion = 0.66667; }
      #
      #            # Fixed sets the width in logical pixels exactly.
      #            # fixed 1920
      #          ];
      #
      #          # You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
      #          # preset-window-heights { }
      #
      #          # You can change the default width of the new windows.
      #          default-column-width = {
      #            proportion = 0.5;
      #          };
      #          # If you leave the brackets empty, the windows themselves will decide their initial width.
      #          # default-column-width {}
      #
      #          # By default focus ring and border are rendered as a solid background rectangle
      #          # behind windows. That is, they will show up through semitransparent windows.
      #          # This is because windows using client-side decorations can have an arbitrary shape.
      #          #
      #          # If you don't like that, you should uncomment `prefer-no-csd` below.
      #          # Niri will draw focus ring and border *around* windows that agree to omit their
      #          # client-side decorations.
      #          #
      #          # Alternatively, you can override it with a window rule called
      #          # `draw-border-with-background`.
      #
      #          # You can change how the focus ring looks.
      #          focus-ring = {
      #            #omment this line to disable the focus ring.
      #            # off
      #
      #            # How many logical pixels the ring extends out from the windows.
      #            width = 4;
      #
      #            # Colors can be set in a variety of ways:
      #            # - CSS named colors: "red"
      #            # - RGB hex: "#rgb", "#rgba", "#rrggbb", "#rrggbbaa"
      #            # - CSS-like notation: "rgb(255, 127, 0)", rgba(), hsl() and a few others.
      #
      #            # Color of the ring on the active monitor.
      #            active = {
      #              color = "#7fc8ff";
      #            };
      #
      #            # Color of the ring on inactive monitors.
      #            #
      #            # The focus ring only draws around the active window, so the only place
      #            # where you can see its inactive-color is on other monitors.
      #            inactive = {
      #              color = "#505050";
      #            };
      #
      #            # You can also use gradients. They take precedence over solid colors.
      #            # Gradients are rendered the same as CSS linear-gradient(angle, from, to).
      #            # The angle is the same as in linear-gradient, and is optional,
      #            # defaulting to 180 (top-to-bottom gradient).
      #            # You can use any CSS linear-gradient tool on the web to set these up.
      #            # Changing the color space is also supported, check the wiki for more info.
      #            #
      #            # active-gradient from="#80c8ff" to="#c7ff7f" angle=45
      #
      #            # You can also color the gradient relative to the entire view
      #            # of the workspace, rather than relative to just the window itself.
      #            # To do that, set relative-to="workspace-view".
      #            #
      #            # inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
      #          };
      #
      #          # You can also add a border. It's similar to the focus ring, but always visible.
      #          border = {
      #            # The settings are the same as for the focus ring.
      #            # If you enable the border, you probably want to disable the focus ring.
      #            enable = true;
      #
      #            width = 4;
      #            active = {
      #              color = "#ffc87f";
      #            };
      #            inactive = {
      #              color = "#505050";
      #            };
      #
      #            # Color of the border around windows that request your attention.
      #            urgent = {
      #              color = "#9b0000";
      #            };
      #
      #            # Gradients can use a few different interpolation color spaces.
      #            # For example, this is a pastel rainbow gradient via in="oklch longer hue".
      #            #
      #            # active-gradient from="#e5989b" to="#ffb4a2" angle=45 relative-to="workspace-view" in="oklch longer hue"
      #
      #            # inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
      #          };
      #
      #          # You can enable drop shadows for windows.
      #          shadow = {
      #            # Uncomment the next line to enable shadows.
      #            # on
      #
      #            # By default, the shadow draws only around its window, and not behind it.
      #            # Uncomment this setting to make the shadow draw behind its window.
      #            #
      #            # Note that niri has no way of knowing about the CSD window corner
      #            # radius. It has to assume that windows have square corners, leading to
      #            # shadow artifacts inside the CSD rounded corners. This setting fixes
      #            # those artifacts.
      #            #
      #            # However, instead you may want to set prefer-no-csd and/or
      #            # geometry-corner-radius. Then, niri will know the corner radius and
      #            # draw the shadow correctly, without having to draw it behind the
      #            # window. These will also remove client-side shadows if the window
      #            # draws any.
      #            #
      #            # draw-behind-window true
      #
      #            # You can change how shadows look. The values below are in logical
      #            # pixels and match the CSS box-shadow properties.
      #
      #            # Softness controls the shadow blur radius.
      #            softness = 30;
      #
      #            # Spread expands the shadow.
      #            spread = 5;
      #
      #            # Offset moves the shadow relative to the window.
      #            offset = {
      #              x = 0;
      #              y = 5;
      #            };
      #
      #            # You can also change the shadow color and opacity.
      #            color = "#0007";
      #          };
      #
      #          # Struts shrink the area occupied by windows, similarly to layer-shell panels.
      #          # You can think of them as a kind of outer gaps. They are set in logical pixels.
      #          # Left and right struts will cause the next window to the side to always be visible.
      #          # Top and bottom struts will simply add outer gaps in addition to the area occupied by
      #          # layer-shell panels and regular gaps.
      #          struts = {
      #            # left 64
      #            # right 64
      #            # top 64
      #            # bottom 64
      #          };
      #        };
      #        # Add lines like this to spawn processes at startup.
      #        # Note that running niri as a session supports xdg-desktop-autostart,
      #        # which may be more convenient to use.
      #        # See the binds section below for more spawn examples.
      #        spawn-at-startup = [
      #          {
      #            command = [ "xwayland-satellite" ];
      #          }
      #        ];
      #        # Uncomment this line to ask the clients to omit their client-side decorations if possible.
      #        # If the client will specifically ask for CSD, the request will be honored.
      #        # Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
      #        # This option will also fix border/focus ring drawing behind some semitransparent windows.
      #        # After enabling or disabling this, you need to restart the apps for this to take effect.
      #        # prefer-no-csd
      #        # You can change the path where screenshots are saved.
      #        # A ~ at the front will be expanded to the home directory.
      #        # The path is formatted with strftime(3) to give you the screenshot date and time.
      #        #sreenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      #        # You can also set this to null to disable saving screenshots to disk.
      #        # screenshot-path null
      #        #/ Animation settings.
      #        # The wiki explains how to configure individual animations:
      #        # https://github.com/YaLTeR/niri/wiki/Configuration:-Animations
      #        animations = {
      #          # Uncomment to turn off all animations.
      #          # off
      #
      #          # Slow down all animations by this factor. Values below 1 speed them up instead.
      #          # slowdown 3.0
      #        };
      #        # Window rules let you adjust behavior for individual windows.
      #        # Find more information on the wiki:
      #        # https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules
      #        #/ Work around WezTerm's initial configure bug
      #        # by setting an empty default-column-width.
      #        window-rules = [
      #          # This regular expression is intentionally made as specific as possible,
      #          # since this is the default config, and we want no false positives.
      #          # You can get away with just app-id="wezterm" if you want.
      #          #match = { app-id=#"^org\.wezfurlong\.wezterm$"\#};
      #          #default-column-width = {}
      #        ];
      #        environment = {
      #          DISPLAY = ":0";
      #        };
      #        binds = with config.lib.niri.actions; {
      #          # App launchers
      #          "Mod+T".action = spawn "alacritty";
      #          "Mod+D".action = spawn "fuzzel";
      #          "Super+Alt+L".action = spawn "swaylock";
      #
      #          # Audio control
      #          "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
      #          "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
      #          "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      #          "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      #
      #          # Brightness control
      #          "XF86MonBrightnessUp".action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
      #          "XF86MonBrightnessDown".action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
      #
      #          # Overview and quitting
      #          "Mod+O".action = toggle-overview;
      #          "Mod+Q".action = close-window;
      #          "Mod+Shift+E".action = quit;
      #          "Mod+Ctrl+Shift+E".action = quit { skip-confirmation = true; };
      #
      #          # Navigation
      #          "Mod+H".action = focus-column-left;
      #          "Mod+J".action = focus-window-down;
      #          "Mod+K".action = focus-window-up;
      #          "Mod+L".action = focus-column-right;
      #
      #          "Mod+Ctrl+H".action = move-column-left;
      #          "Mod+Ctrl+J".action = move-window-down;
      #          "Mod+Ctrl+K".action = move-window-up;
      #          "Mod+Ctrl+L".action = move-column-right;
      #
      #          "Mod+Shift+H".action = focus-monitor-left;
      #          "Mod+Shift+J".action = focus-monitor-down;
      #          "Mod+Shift+K".action = focus-monitor-up;
      #          "Mod+Shift+L".action = focus-monitor-right;
      #
      #          "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
      #          "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
      #          "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
      #          "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
      #
      #          "Mod+U".action = focus-workspace-down;
      #          "Mod+I".action = focus-workspace-up;
      #          "Mod+Ctrl+U".action = move-column-to-workspace-down;
      #          "Mod+Ctrl+I".action = move-column-to-workspace-up;
      #          "Mod+Shift+U".action = move-workspace-down;
      #          "Mod+Shift+I".action = move-workspace-up;
      #
      #          # Scroll bindings
      #          "Mod+WheelScrollDown".action = focus-workspace-down;
      #          "Mod+WheelScrollUp".action = focus-workspace-up;
      #          "Mod+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
      #          "Mod+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;
      #
      #          "Mod+WheelScrollLeft".action = focus-column-left;
      #          "Mod+WheelScrollRight".action = focus-column-right;
      #          "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
      #          "Mod+Ctrl+WheelScrollRight".action = move-column-right;
      #
      #          "Mod+Shift+WheelScrollUp".action = focus-column-left;
      #          "Mod+Shift+WheelScrollDown".action = focus-column-right;
      #          "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;
      #          "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
      #
      #          # Workspace numbers (1–9)
      #          "Mod+1".action = focus-workspace 1;
      #          "Mod+2".action = focus-workspace 2;
      #          "Mod+3".action = focus-workspace 3;
      #          "Mod+4".action = focus-workspace 4;
      #          "Mod+5".action = focus-workspace 5;
      #          "Mod+6".action = focus-workspace 6;
      #          "Mod+7".action = focus-workspace 7;
      #          "Mod+8".action = focus-workspace 8;
      #          "Mod+9".action = focus-workspace 9;
      #
      #          "Mod+Ctrl+1".action = move-column-to-workspace 1;
      #          "Mod+Ctrl+2".action = move-column-to-workspace 2;
      #          "Mod+Ctrl+3".action = move-column-to-workspace 3;
      #          "Mod+Ctrl+4".action = move-column-to-workspace 4;
      #          "Mod+Ctrl+5".action = move-column-to-workspace 5;
      #          "Mod+Ctrl+6".action = move-column-to-workspace 6;
      #          "Mod+Ctrl+7".action = move-column-to-workspace 7;
      #          "Mod+Ctrl+8".action = move-column-to-workspace 8;
      #          "Mod+Ctrl+9".action = move-column-to-workspace 9;
      #
      #          # Window & column management
      #          "Mod+Comma".action = consume-window-into-column;
      #          "Mod+Period".action = expel-window-from-column;
      #          "Mod+BracketLeft".action = consume-or-expel-window-left;
      #          "Mod+BracketRight".action = consume-or-expel-window-right;
      #
      #          "Mod+F".action = maximize-column;
      #          "Mod+Shift+F".action = fullscreen-window;
      #          "Mod+Ctrl+F".action = expand-column-to-available-width;
      #
      #          "Mod+C".action = center-column;
      #          "Mod+Ctrl+C".action = center-visible-columns;
      #
      #          "Mod+Minus".action = set-column-width "-10%";
      #          "Mod+Plus".action = set-column-width "+10%";
      #          "Mod+Shift+Minus".action = set-window-height "-10%";
      #          "Mod+Shift+Plus".action = set-window-height "+10%";
      #
      #          "Mod+R".action = switch-preset-column-width;
      #          "Mod+Shift+R".action = switch-preset-window-height;
      #          "Mod+Ctrl+R".action = reset-window-height;
      #
      #          "Mod+V".action = toggle-window-floating;
      #          "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
      #
      #          "Mod+W".action = toggle-column-tabbed-display;
      #
      #          # Screenshots
      #          "Print".action = screenshot { show-pointer = false; };
      #          #"Ctrl+Print".action = screenshot-screen;
      #          "Alt+Print".action = screenshot-window;
      #
      #          # Other
      #          "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
      #          "Mod+Shift+P".action = power-off-monitors;
      #        };
      #      };
    };
  };
}
