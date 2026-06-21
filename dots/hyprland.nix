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
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";

  hypr-portal =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  hypr-split =
    inputs.hyprland-hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces;

  hypr-pkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hymission = hypr-pkg.stdenv.mkDerivation {
    pname = "hymission";
    version = "0.3.3-unstable-${inputs.hymission.shortRev or "dirty"}";
    src = inputs.hymission;

    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
    ];
    buildInputs = [ hypr-pkg ] ++ hypr-pkg.buildInputs;

    meta = {
      description = "Mission Control-style overview plugin for Hyprland";
      homepage = "https://github.com/gfhdhytghd/hymission";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  };
  # hyprscrolling was upstreamed into Hyprland core in 0.54 as the "scrolling" layout.
  # No plugin is needed; configure via the top-level `scrolling { ... }` block.
  mod = "Alt";
  terminal = "footclient";
  fileManager = "thunar";
  #runner = "${lib.getExe caelestia-cli} shell drawers toggle launcher";
  runner = "dms ipc call spotlight toggle";
  # runner     = "anyrun";
  browser = "firefox";
  editor = "emacsclient -c";

  enabled = window_manager == "hyprland" || window_manager == "all";
  kbLayout = if isLaptop then "ie" else "us";
in
{
  wayland.windowManager.hyprland = {
    enable = enabled;
    package = null; # Use the system package from programs.hyprland to avoid duplicate sessions
    portalPackage = hypr-portal;
  };

  # ─── Hyprland 0.55+ Lua config ────────────────────────────────────────────────
  # Loaded in preference to hyprland.conf when Hyprland >= 0.55 is in use.
  # On older Hyprland this file is ignored and the `settings` block above is used.
  xdg.configFile."hypr/hyprland.lua" = lib.mkIf enabled {
    text = ''
      -- Generated from dots/hyprland.nix.

      ----------------------------------------------------------------------------
      -- DMS-generated config (cursor + outputs own monitors and cursor theme).
      -- Remove a require to take over that file's settings yourself.
      ----------------------------------------------------------------------------
      require("dms.cursor")
      require("dms.colors")
      require("dms.outputs")

      ----------------------------------------------------------------------------
      -- Plugins + autostart
      ----------------------------------------------------------------------------
      hl.on("hyprland.start", function()
        hl.exec_cmd("sh -c 'hyprctl plugin load ${hypr-split}/lib/libsplit-monitor-workspaces.so'")
        -- Load hymission, then apply its config keys. We chain the keyword
        -- calls onto the load with `&&` in a single shell invocation so the
        -- config is applied only after the plugin has registered its keys
        -- (otherwise we'd race against the async load and get "unknown config
        -- key" errors).
        -- hl.exec_cmd("sh -c 'hyprctl plugin load ${hymission}/lib/libhymission.so && hyprctl keyword plugin:hymission:niri_mode 1 && hyprctl keyword plugin:hymission:workspace_strip_anchor left'")

        hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
        hl.exec_cmd("fcitx5 -d")
        hl.exec_cmd("foot -s")
        hl.exec_cmd("systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP QT_QPA_PLATFORMTHEME GTK_THEME XCURSOR_THEME XCURSOR_SIZE")
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")
      end)

      ----------------------------------------------------------------------------
      -- Look and feel
      ----------------------------------------------------------------------------
      hl.config({
        general = {
          gaps_in          = 5,
          gaps_out         = 10,
          border_size      = 2,
          resize_on_border = false,
          allow_tearing    = false,
          layout           = "scrolling",
        },

        render = {
          cm_enabled        = true,
          cm_auto_hdr       = 1,
          send_content_type = true,
        },

        decoration = {
          rounding         = 0,
          rounding_power   = 0,
          active_opacity   = 1.0,
          inactive_opacity = 1.0,

          shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
          },

          blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
          },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true,
          force_split    = 2,
        },

        master = {
          new_status = "master",
          mfact      = 0.5,
          new_on_top = true,
        },

        -- Built-in scrolling layout (since Hyprland 0.54).
        scrolling = {
          column_width             = 0.9,
          follow_focus             = true,
          focus_fit_method         = 0, -- 0 = center the focused column, 1 = fit
          fullscreen_on_one_column = true,
        },

        misc = {
          force_default_wallpaper = -1,
          disable_hyprland_logo   = true,
          enable_swallow          = true,
          swallow_regex           = "footclient",
        },

        input = {
          kb_layout    = "${kbLayout}",
          repeat_rate  = 40,
          repeat_delay = 500,
          follow_mouse = 1,
          sensitivity  = 0,
          touchpad = {
            natural_scroll = false,
          },
        },

        gestures = {
          scrolling = {
            -- Don't snap the cursor to the newly focused window after a
            -- 3-finger scroll_move gesture. Keep warps for keybind focus
            -- changes / popups (those use cursor:no_warps, left at default).
            move_snap_cursor = false,
          },
        },

        -- split-monitor-workspaces config is omitted on purpose: its defaults
        -- already are { count = 10, enable_persistent_workspaces = 1 }, and
        -- because the plugin is loaded via the `hyprland.start` hook below
        -- (asynchronously, after this hl.config call runs), setting these
        -- keys here would fire "unknown config key" errors at parse time.
        -- Override with `hyprctl keyword plugin:split-monitor-workspaces:<key> <val>`
        -- at runtime if you ever need to change them.
      })

      ----------------------------------------------------------------------------
      -- Animation curves + leaves
      ----------------------------------------------------------------------------
      hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
      hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
      hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
      hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

      hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
      hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
      hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "slidevert" })
      hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "slidevert" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slidevert" })

      ----------------------------------------------------------------------------
      -- Trackpad gestures (niri-style)
      --   3-finger horizontal swipe = scroll the scrolling-layout tape
      --   4-finger horizontal swipe = switch workspaces
      ----------------------------------------------------------------------------
      hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
      hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

      ----------------------------------------------------------------------------
      -- Devices
      ----------------------------------------------------------------------------
      hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

      ----------------------------------------------------------------------------
      -- Keybindings
      ----------------------------------------------------------------------------
      local mod = "ALT"

      -- bind(modkey, modifier, key, action, opts?)
      --   Any of modkey / modifier may be "" to omit (e.g. XF86 keys have no mod).
      --   opts is the optional table forwarded to hl.bind (locked, repeating, mouse, ...).
      function bind(modkey, modifier, key, action, opts)
        local parts = {}
        if modkey   and modkey   ~= "" then parts[#parts + 1] = modkey   end
        if modifier and modifier ~= "" then parts[#parts + 1] = modifier end
        if key      and key      ~= "" then parts[#parts + 1] = key      end
        local combo = table.concat(parts, " + ")
        if opts then
          hl.bind(combo, action, opts)
        else
          hl.bind(combo, action)
        end
      end

      local binds = {
        -- Launcher / apps
        { mod, "", "Return", hl.dsp.exec_cmd("${terminal}")    },
        { mod, "", "B",      hl.dsp.exec_cmd("${browser}")     },
        { mod, "", "F",      hl.dsp.exec_cmd("${fileManager}") },
        { mod, "", "D",      hl.dsp.exec_cmd("${runner}")      },
        { mod, "", "E",      hl.dsp.exec_cmd("${editor}")      },

        -- Session / window controls
        { mod, "", "Q",         hl.dsp.window.close() },
        { mod, "", "M",         hl.dsp.exit() },
        { mod, "", "V",         hl.dsp.window.float({ action = "toggle" }) },
        { mod, "", "T",         hl.dsp.window.fullscreen() },
        { "",  "", "Print",     hl.dsp.exec_cmd("dms screenshot") },
        { mod, "", "F1",        hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland") },
        { mod, "", "BACKSLASH", hl.dsp.exec_cmd("dms ipc call notepad toggle") },

        -- Dwindle pseudotile
        { mod, "", "P", hl.dsp.window.pseudo() },

        -- Focus
        { mod, "", "H", hl.dsp.focus({ direction = "left"  }) },
        { mod, "", "L", hl.dsp.focus({ direction = "right" }) },
        { mod, "", "K", hl.dsp.focus({ direction = "up"    }) },
        { mod, "", "J", hl.dsp.focus({ direction = "down"  }) },

        -- Move window
        { mod, "SHIFT", "H", hl.dsp.window.move({ direction = "left"  }) },
        { mod, "SHIFT", "L", hl.dsp.window.move({ direction = "right" }) },
        { mod, "SHIFT", "K", hl.dsp.window.move({ direction = "up"    }) },
        { mod, "SHIFT", "J", hl.dsp.window.move({ direction = "down"  }) },

        -- Promote (works for both master + scrolling)
        { mod, "", "semicolon", hl.dsp.layout("promote") },

        -- Scrolling-layout column movement
        { mod, "", "period", hl.dsp.layout("move +col") },
        { mod, "", "comma",  hl.dsp.layout("move -col") },

        -- Special workspace (scratchpad)
        { mod, "",      "SLASH", hl.dsp.workspace.toggle_special("magic") },
        { mod, "SHIFT", "SLASH", hl.dsp.window.move({ workspace = "special:magic" }) },

        -- Scroll workspaces with mod + wheel
        { mod, "", "mouse_down", hl.dsp.focus({ workspace = "e+1" }) },
        { mod, "", "mouse_up",   hl.dsp.focus({ workspace = "e-1" }) },

        -- 8BitDo big red B button
        { mod, "SHIFT", "F1", hl.dsp.exec_cmd("scrcpy --video-source=camera -m3000 --camera-facing=back --v4l2-sink=/dev/video1 --no-video-playback --no-audio") },

        -- Mouse drag / resize
        { mod, "", "mouse:272", hl.dsp.window.drag(),   { mouse = true } },
        { mod, "", "mouse:273", hl.dsp.window.resize(), { mouse = true } },

        -- Volume / brightness (locked + repeating)
        { "", "", "XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pamixer -i 5"),                                                    { locked = true, repeating = true } },
        { "", "", "XF86AudioLowerVolume",  hl.dsp.exec_cmd("pamixer -d 5"),                                                    { locked = true, repeating = true } },
        { "", "", "XF86AudioMute",         hl.dsp.exec_cmd("pamixer --toggle-mute"),                                           { locked = true } },
        { "", "", "XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                    { locked = true } },
        { "", "", "XF86MonBrightnessUp",   hl.dsp.exec_cmd("dms ipc call brightness increment 5 backlight:intel_backlight"),   { locked = true, repeating = true } },
        { "", "", "XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement 5 backlight:intel_backlight"),   { locked = true, repeating = true } },

        -- Media (locked)
        { "", "", "XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true } },
        { "", "", "XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
        { "", "", "XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
        { "", "", "XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true } },
      }

      for _, b in ipairs(binds) do
        bind(b[1], b[2], b[3], b[4], b[5])
      end

      -- Workspaces (split-monitor-workspaces from Duckonaut).
      -- The plugin is loaded asynchronously in the `hyprland.start` hook above,
      -- so we cannot capture `hl.plugin.split_monitor_workspaces` at parse time.
      -- Wrap each bind in a function so the lookup happens at key-press time.
      for i = 1, 10 do
        local n   = i              -- capture loop variable
        local key = tostring(n % 10) -- 10 maps to key 0
        bind(mod, "",      key, function() return hl.plugin.split_monitor_workspaces.workspace(n) end)
        bind(mod, "SHIFT", key, function() return hl.plugin.split_monitor_workspaces.move_to_workspace_silent(n) end)
      end



      ----------------------------------------------------------------------------
      -- Window rules
      ----------------------------------------------------------------------------
      hl.window_rule({
        name           = "suppress-maximize-events",
        match          = { class = ".*" },
        suppress_event = "maximize",
      })

      hl.window_rule({
        name  = "fix-xwayland-drags",
        match = {
          class      = "^$",
          title      = "^$",
          xwayland   = true,
          float      = true,
          fullscreen = false,
          pin        = false,
        },
        no_focus = true,
      })

      hl.window_rule({
        name   = "screen-share-picker-float",
        match  = { title = "^(Select what to share)$" },
        float  = true,
      })

      hl.window_rule({
        name   = "screen-share-picker-center",
        match  = { title = "^(Select what to share)$" },
        center = true,
      })
    '';
  };
}
