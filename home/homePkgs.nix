{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # hyprlock = pkgs.callPackage ../../universal/personalPKGS/hyprlock.nix {};
  # hypridle = pkgs.callPackage ../../universal/personalPKGS/hypridle.nix {};

  defaultProfile = {
    id = 0;
    name = "default";
    isDefault = true;
  };

  anyrunPlugins = with pkgs.anyrun; [
    "${pkgs.anyrun}/lib/libapplications.so"
    "${pkgs.anyrun}/lib/libdictionary.so"
    "${pkgs.anyrun}/lib/libsymbols.so"
    "${pkgs.anyrun}/lib/librink.so"
    "${pkgs.anyrun}/lib/libtranslate.so"
    "${pkgs.anyrun}/lib/libwebsearch.so"
  ];
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.caelestia.homeManagerModules.default
  ];

  programs = {
    zen-browser = {
      enable = true;
      profiles.default = defaultProfile;
    };

    firefox = {
      enable = true;
      profiles.default = defaultProfile;
    };
    caelestia = {
      enable = true;
      systemd = {
        enable = true; # if you prefer starting from your compositor
        target = "graphical-session.target";
        environment = [];
      };
      settings = {  
        appearance = {
          anim = {
            durations = {
              scale = 1;
            };
          };
          font = {
            family = {
              material = "Material Symbols Rounded";
              mono = "CaskaydiaCove NF";
              sans = "Rubik";
            };
            size = {
              scale = 1;
            };
          };
          padding = {
            scale = 1;
          };
          rounding = {
            scale = 1;
          };
          spacing = {
            scale = 1;
          };
          transparency = {
            enabled = false;
            base = 0.85;
            layers = 0.4;
          };
        };
        general = {
          apps = {
            terminal = [ "foot" ];
            audio = [ "pavucontrol" ];
          };
          battery = {
            warnLevels = [
              {
                level = 20;
                title = "Low battery";
                message = "You might want to plug in a charger";
                icon = "battery_android_frame_2";
              }
              {
                level = 10;
                title = "Did you see the previous message?";
                message = "You should probably plug in a charger <b>now</b>";
                icon = "battery_android_frame_1";
              }
              {
                level = 5;
                title = "Critical battery level";
                message = "PLUG THE CHARGER RIGHT NOW!!";
                icon = "battery_android_alert";
                critical = true;
              }
            ];
            criticalLevel = 3;
          };
          idle = {
            inhibitWhenAudio = true;
            timeouts = [
              {
                timeout = 180;
                idleAction = "lock";
              }
              {
                timeout = 300;
                idleAction = "dpms off";
                returnAction = "dpms on";
              }
              {
                timeout = 600;
                idleAction = [ "systemctl" "suspend-then-hibernate" ];
              }
            ];
          };
        };
        background = {
          desktopClock = {
            enabled = false;
          };
          enabled = true;
          visualiser = {
            enabled = false;
            autoHide = true;
            rounding = 1;
            spacing = 1;
          };
        };
        bar = {
          clock = {
            showIcon = true;
          };
          dragThreshold = 20;
          entries = [
            {
              id = "logo";
              enabled = true;
            }
            {
              id = "workspaces";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "activeWindow";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "tray";
              enabled = true;
            }
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "statusIcons";
              enabled = true;
            }
            {
              id = "power";
              enabled = true;
            }
          ];
          persistent = true;
          scrollActions = {
            brightness = true;
            workspaces = true;
            volume = true;
          };
          showOnHover = true;
          status = {
            showAudio = false;
            showBattery = true;
            showBluetooth = true;
            showKbLayout = false;
            showMicrophone = false;
            showNetwork = true;
            showLockStatus = true;
          };
          tray = {
            background = false;
            iconSubs = [];
            recolour = false;
          };
          workspaces = {
            activeIndicator = true;
            activeLabel = "󰮯";
            activeTrail = false;
            label = "  ";
            occupiedBg = false;
            occupiedLabel = "󰮯";
            perMonitorWorkspaces = true;
            showWindows = true;
            shown = 5;
          };
        };
        border = {
          rounding = 25;
          thickness = 10;
        };
        dashboard = {
          enabled = true;
          dragThreshold = 50;
          mediaUpdateInterval = 500;
          showOnHover = true;
        };
        launcher = {
          actionPrefix = ">";
          actions = [
            {
              name = "Calculator";
              icon = "calculate";
              description = "Do simple math equations (powered by Qalc)";
              command = [ "autocomplete" "calc" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Scheme";
              icon = "palette";
              description = "Change the current colour scheme";
              command = [ "autocomplete" "scheme" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Wallpaper";
              icon = "image";
              description = "Change the current wallpaper";
              command = [ "autocomplete" "wallpaper" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Variant";
              icon = "colors";
              description = "Change the current scheme variant";
              command = [ "autocomplete" "variant" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Transparency";
              icon = "opacity";
              description = "Change shell transparency";
              command = [ "autocomplete" "transparency" ];
              enabled = false;
              dangerous = false;
            }
            {
              name = "Random";
              icon = "casino";
              description = "Switch to a random wallpaper";
              command = [ "caelestia" "wallpaper" "-r" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Light";
              icon = "light_mode";
              description = "Change the scheme to light mode";
              command = [ "setMode" "light" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Dark";
              icon = "dark_mode";
              description = "Change the scheme to dark mode";
              command = [ "setMode" "dark" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Shutdown";
              icon = "power_settings_new";
              description = "Shutdown the system";
              command = [ "systemctl" "poweroff" ];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Reboot";
              icon = "cached";
              description = "Reboot the system";
              command = [ "systemctl" "reboot" ];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Logout";
              icon = "exit_to_app";
              description = "Log out of the current session";
              command = [ "loginctl" "terminate-user" "" ];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Lock";
              icon = "lock";
              description = "Lock the current session";
              command = [ "caelestia" "shell" "lock" "lock" ];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Sleep";
              icon = "bedtime";
              description = "Suspend then hibernate";
              command = [ "systemctl" "suspend-then-hibernate" ];
              enabled = true;
              dangerous = false;
            }
          ];
          dragThreshold = 50;
          vimKeybinds = false;
          enableDangerousActions = false;
          maxShown = 7;
          maxWallpapers = 9;
          specialPrefix = "@";
          useFuzzy = {
            apps = false;
            actions = false;
            schemes = false;
            variants = false;
            wallpapers = false;
          };
          showOnHover = false;
          hiddenApps = [];
        };
        lock = {
          recolourLogo = false;
        };
        notifs = {
          actionOnClick = false;
          clearThreshold = 0.3;
          defaultExpireTimeout = 5000;
          expandThreshold = 20;
          expire = false;
        };
        osd = {
          enabled = true;
          enableBrightness = true;
          enableMicrophone = false;
          hideDelay = 2000;
        };
        paths = {
          mediaGif = "root:/assets/bongocat.gif";
          sessionGif = "root:/assets/kurukuru.gif";
          wallpaperDir = "~/Pictures/Wallpapers";
        };
        services = {
          audioIncrement = 0.1;
          defaultPlayer = "Spotify";
          playerAliases = [
            { from = "com.github.th_ch.youtube_music"; to = "YT Music"; }
          ];
          gpuType = "";
          weatherLocation = "";
          useFahrenheit = false;
          useTwelveHourClock = false;
          smartScheme = true;
          visualiserBars = 45;
        };
        session = {
          dragThreshold = 30;
          enabled = true;
          vimKeybinds = false;
          commands = {
            logout = [ "loginctl" "terminate-user" "" ];
            shutdown = [ "systemctl" "poweroff" ];
            hibernate = [ "systemctl" "hibernate" ];
            reboot = [ "systemctl" "reboot" ];
          };
        };
        sidebar = {
          dragThreshold = 80;
          enabled = true;
        };
        utilities = {
          enabled = true;
          maxToasts = 4;
          toasts = {
            audioInputChanged = true;
            audioOutputChanged = true;
            capsLockChanged = true;
            chargingChanged = true;
            configLoaded = true;
            dndChanged = true;
            gameModeChanged = true;
            numLockChanged = true;
          };
        };

      };
      cli = {
        enable = true; # Also add caelestia-cli to path
        settings = {
          theme.enableGtk = false;
        };
      };
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    lazygit.enable = true;

    vscode = {
      enable = true;
      profiles.default.extensions = [
        pkgs.vscode-extensions.platformio.platformio-vscode-ide
      ];
    };

    anyrun = {
      enable = true;
      config = {
        plugins = anyrunPlugins;
        x.fraction = 0.5;
        y.fraction = 0.3;
        width.fraction = 0.3;
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
      extraCss = ''
        .some_class
        enable = true;{
          background: red;
        }
      '';
      extraConfigFiles."websearch.ron".text = ''
        Config(
          prefix: "",
          engines: [Google]
        )
      '';
      extraConfigFiles."dictionary.ron".text = ''
        Config(
          prefix: "",
          max_entries: 5,
        )
      '';
      extraConfigFiles."rink.ron".text = ''
        Config(
          prefix: "",
          max_entries: 5,
        )
      '';
      extraConfigFiles."translate.ron".text = ''
        Config(
          prefix: ":",
          language_delimiter: ">",
          max_entries: 3,
        )
      '';
      extraConfigFiles."symbols.ron".text = ''
        Config (
          prefix: "",
          // Custom user defined symbols to be included along the unicode symbols
          symbols: {
            // "name": "text to be copied"
            "shrug": "¯\\_(ツ)_/¯",
          },
          max_entries: 3,
        )
      '';
    };
  };

  qt.enable = true;
  # qt.style = "gtk2";
  # qt.platformTheme = "qt5ct";
  # imports = [ inputs.anyrun.homeManagerModules.default ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
        "qtwebengine-5.15.19"
      ];
    };
  };

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    ############################
    # Shells & Terminals
    ############################
    alacritty
    zsh

    ############################
    # CLI Shit
    ############################
    atuin

    ############################
    # System Utilities
    ############################
    app2unit
    brightnessctl
    ddcutil
    duf
    libnotify
    lm_sensors
    macchina
    rm-improved
    xarchiver
    xdg-user-dirs

    ############################
    # Monitoring & TUI Apps
    ############################
    btop
    cava

    ############################
    # Wayland / Desktop Tools
    ############################
    grim
    hyprpaper
    hyprpicker
    mangohud
    rofi
    slurp
    swappy
    wf-recorder

    ############################
    # Audio / Media Tools
    ############################
    openai-whisper
    pamixer
    playerctl
    alsa-utils

    ############################
    # Browsers & Web
    ############################
    brave
    firefox
    zoom-us

    ############################
    # Communication & Sharing
    ############################
    element-desktop
    localsend
    slack
    thunderbird

    ############################
    # Documents & Viewers
    ############################
    libreoffice
    libreoffice-fresh
    zathura

    ############################
    # Media Players & Imaging
    ############################
    imv
    mpv
    upscaler
    youtube-music
    libsixel

    ############################
    # Development Toolchains
    ############################
    gdb
    nodejs_20
    platformio
    rustc
    rustup
    zed-editor

    # Language tooling from inputs
    inputs.qs-qml.packages.${pkgs.system}.qml-ts-mode
    inputs.qs-qml.packages.${pkgs.system}.tree-sitter-qmljs

    ############################
    # Game Dev / Engines
    ############################
    blender-hip
    godot_4

    ############################
    # Emulation
    ############################
    fuse
    fuse-emulator
    fuse3

    ############################
    # Android Tools
    ############################
    android-tools
    scrcpy

    ############################
    # Gaming & Launchers
    ############################
    dualsensectl
    gamemode
    goverlay
    heroic
    prismlauncher
    protonup-qt
    wineWowPackages.stable
    mangayomi
    rink

    ############################
    # KDE / File Management
    ############################
    kdePackages.baloo # new
    kdePackages.baloo-widgets # new
    kdePackages.dolphin
    kdePackages.ffmpegthumbs # new
    kdePackages.kdegraphics-mobipocket # new
    kdePackages.kdegraphics-thumbnailers # new
    kdePackages.kdesdk-thumbnailers # new
    kdePackages.kimageformats # new
    kdePackages.kio
    kdePackages.kio-extras
    # kdePackages.breeze-icons
    # kdePackages.dolphin-plugins
    # kdePackages.kde-cli-tools
    # resvg # new

    ############################
    # Blockchain (inputs)
    ############################
    #inputs.caelestia-cli.packages.${pkgs.system}.caelestia-cli
    #inputs.caelestia.packages.${pkgs.system}.caelestia-shell
  ];
}
