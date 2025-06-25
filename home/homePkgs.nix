{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
in
#hyprlock = pkgs.callPackage ../../universal/personalPKGS/hyprlock.nix {};
#hypridle = pkgs.callPackage ../../universal/personalPKGS/hypridle.nix {};
{

  programs.lazygit.enable = true;

  qt.enable = true;
  #qt.style = "gtk2";
  #qt.platformTheme = "qt5ct";
  #imports = [ inputs.anyrun.homeManagerModules.default ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];
  programs.vscode = {
    enable = true;
  };
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libdictionary.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libtranslate.so"
        "${pkgs.anyrun}/lib/libwebsearch.so"
      ];
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
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
        // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
        //
        // Custom engines can be defined as such:
        // Custom(
        //   name: "Searx",
        //   url: "searx.be/?q={}",
        // )
        //
        // NOTE: `{}` is replaced by the search query and `https://` is automatically added in front.
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
              // The prefix that the search needs to begin with to yield symbol results
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
  services.kdeconnect.enable = true;

  home.packages = with pkgs; [

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    zsh
    zoom-us
    rink
    firefox
    btop
    libreoffice-fresh
    rustup
    rustc
    macchina
    hyprpaper
    obs-studio
    #xwaylandvideobridge
    duf
    grim
    slurp
    swappy
    heroic
    gamemode
    gamescope
    goverlay
    rm-improved
    nodejs_20
    playerctl
    pamixer
    openai-whisper
    libreoffice
    zathura
    imv
    libsixel
    prismlauncher
    godot_4
    wf-recorder
    jellyfin-media-player
    pcmanfm
    hyprpicker
    mangohud
    gamemode
    #discord
    mpv
    rofi
    xdg-user-dirs
    xarchiver
    atuin
    blender-hip
    wineWowPackages.stable
    gdb
    alsa-utils
    brave
    slack
    zed-editor
    dualsensectl
    mangayomi
    element-desktop
    scrcpy
    fuse
    fuse-emulator
    fuse3
    alacritty
    networkmanagerapplet
    #inputs.way-inhibitor.packages.${pkgs.system}.default
    inputs.zen-browser.packages.${pkgs.system}.twilight
    #inputs.quickshell.packages.${pkgs.system}.default
    inputs.qs-qml.packages.${pkgs.system}.tree-sitter-qmljs
    inputs.qs-qml.packages.${pkgs.system}.qml-ts-mode
    lxqt.pcmanfm-qt
    protonup-qt
    ddcutil
    brightnessctl
    app2unit
    cava
    lm_sensors
    thunderbird
    wmctrl
    xdotool
    libinput-gestures
    touchegg
  ];
}
