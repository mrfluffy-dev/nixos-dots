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
    ladybird

    ############################
    # Communication & Sharing
    ############################
    element-desktop
    localsend
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
    # Experimental (inputs)
    ############################
    #inputs.ladybird.packages."${pkgs.system}".ladybird
    inputs.hyprlauncher.packages.${pkgs.system}.default

    ############################
    # Blockchain (inputs)
    ############################
    #inputs.caelestia-cli.packages.${pkgs.system}.caelestia-cli
    #inputs.caelestia.packages.${pkgs.system}.caelestia-shell
  ];
}
