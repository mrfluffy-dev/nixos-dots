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
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.caelestia.homeManagerModules.default
    inputs.vicinae.homeManagerModules.default
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

      # Key fix: don’t let the CLI touch ~/.vscode/extensions
      mutableExtensionsDir = false;

      # (Optional but nice) Use a build with a stable headless CLI:
      # package = pkgs.vscodium;   # or keep pkgs.vscode

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          platformio.platformio-vscode-ide
          ms-vscode.cpptools
        ];

        # Optional: keep Code from trying to self-update
        # userSettings = {
        #   "update.mode" = "none";
        #   "extensions.autoUpdate" = false;
        # };
      };

      # Optional (older HM versions expose these at top-level):
      # enableUpdateCheck = false;
      # enableExtensionUpdateCheck = false;
    };

  };

  services.vicinae = {
    enable = true; # default: false
    systemd = {
      enable = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    #package = # specify package to use here. Can be omitted.
    # Installing (vicinae) extensions declaratively
    #settings = {
    #  faviconService = "twenty"; # twenty | google | none
    #  font.size = 11;
    #  popToRootOnClose = false;
    #  rootSearch.searchFiles = false;
    #  theme.name = "vicinae-dark";
    #  window = {
    #    csd = true;
    #    opacity = 0.95;
    #    rounding = 10;
    #  };
    #};
    #extensions = [
    #  (inputs.vicinae.mkVicinaeExtension.${pkgs.stdenv.hostPlatform.system} {
    #    inherit pkgs;
    #    name = "extension-name";
    #    src = pkgs.fetchFromGitHub {
    #      # You can also specify different sources other than github
    #      owner = "repo-owner";
    #      repo = "repo-name";
    #      rev = "v1.0"; # If the extension has no releases use the latest commit hash
    #      # You can get the sha256 by rebuilding once and then copying the output hash from the error message
    #      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #    }; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
    #  })
    #];
  };

  qt.enable = true;
  # qt.style = "gtk2";
  # qt.platformTheme = "qt5ct";

  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
        "qtwebengine-5.15.19"
      ];
      rocmSupport = true;
    };
  };

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    # ─── Shells & Terminals ──────────────────────────────────────────────────────
    alacritty
    zsh

    # ─── CLI Shit ────────────────────────────────────────────────────────────────
    atuin

    # ─── System Utilities ──────────────────────────────────────────────────────────
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

    # ─── Monitoring & TUI Apps ───────────────────────────────────────────────────
    btop
    cava

    # ─── Wayland / Desktop Tools ─────────────────────────────────────────────────
    grim
    hyprpaper
    hyprpicker
    mangohud
    rofi
    slurp
    swappy
    wf-recorder

    # ─── Audio / Media Tools ─────────────────────────────────────────────────────
    openai-whisper
    pamixer
    playerctl
    alsa-utils

    # ─── Browsers & Web ────────────────────────────────────────────────────────────
    brave
    firefox
    ladybird
    wgnord

    # ─── Communication & Sharing ─────────────────────────────────────────────────
    #element-desktop
    localsend
    thunderbird

    # ─── Documents & Viewers ─────────────────────────────────────────────────────
    libreoffice-fresh
    zathura

    # ─── Media Players & Imaging ─────────────────────────────────────────────────
    imv
    mpv
    #upscaler
    pear-desktop
    libsixel

    # ─── Development Toolchains ──────────────────────────────────────────────────
    gdb
    nodejs_20
    platformio
    rustc
    rustup
    zed-editor
    android-studio-full
    claude-code
    # Language tooling from inputs
    #inputs.qs-qml.packages.${pkgs.stdenv.hostPlatform.system}.qml-ts-mode
    #inputs.qs-qml.packages.${pkgs.stdenv.hostPlatform.system}.tree-sitter-qmljs

    # ─── Game Dev / Engines / Creative ──────────────────────────────────────────
    blender
    godot_4
    freecad

    # ─── Emulation ────────────────────────────────────────────────────────────────
    fuse
    fuse-emulator
    fuse3

    # ─── Android Tools ───────────────────────────────────────────────────────────
    android-tools
    scrcpy

    # ─── Gaming & Launchers ──────────────────────────────────────────────────────
    dualsensectl
    gamemode
    goverlay
    (pkgs.heroic.override {
      extraPkgs = pkgs: [ pkgs.gamescope ]; # pulls in the real package
    })
    prismlauncher
    protonup-qt
    wineWowPackages.stable
    mangayomi
    rink
    protontricks

    abaddon

    # ─── KDE / File Management ───────────────────────────────────────────────────
    kdePackages.qt6ct
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
    adwaita-icon-theme
    hicolor-icon-theme
    qt6.qtsvg

    adw-gtk3
    pywalfox-native

    # ─── Experimental (inputs) ───────────────────────────────────────────────────
    #inputs.ladybird.packages."${pkgs.stdenv.hostPlatform.system}".ladybird
    #inputs.hyprlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default

    # ─── Blockchain (inputs) ─────────────────────────────────────────────────────
    #inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-cli
    #inputs.caelestia.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-shell
  ];
}
