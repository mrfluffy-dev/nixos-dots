{
  config,
  pkgs,
  inputs,
  ...
}:
let
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeManagerModules.stylix
    ../../universal/dots/foot/foot.nix
    ./stylix.nix
    ../../universal/homePkgs.nix

  ];

  # you can go look here for a list of color schemes https://github.com/tinted-theming/schemes
  colorScheme = inputs.nix-colors.colorSchemes.dracula;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mrfluffy";
  home.homeDirectory = "/home/mrfluffy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  gtk = {
    enable = true;
    #theme = {
    #  name = "Dracula";
    #  package = pkgs.dracula-theme;
    #};
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    #cursorTheme = {
    #  name = "oreo_purple_cursors";
    #};
  };
  xdg = {
    enable = true;
    portal = {
      enable = true;
      config.common.default = [
        "river"
        "gtk"
      ];
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = [ "zen_twilight.desktop" ];
          fileManager = [ "pcmanfm.desktop" ];
          editor = [ "emacs.desktop" ];
          player = [ "mpv.desktop" ];
          viewer = [ "imv.desktop" ];
          reader = [ "org.pwmt.zathura.desktop" ];
        in
        {
          "application/pdf" = reader;
          "application/epub" = reader;

          "text/html" = browser;
          "text/xml" = browser;
          "text/plain" = editor;
          "application/x-wine-extension-ini" = editor;

          "application/json" = browser;
          "application/xml" = browser;
          "application/xhtml+xml" = browser;
          "application/xhtml_xml" = browser;
          "application/rdf+xml" = browser;
          "application/rss+xml" = browser;
          "application/x-extension-htm" = browser;
          "application/x-extension-html" = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xht" = browser;
          "application/x-extension-xhtml" = browser;

          "x-scheme-handler/about" = browser;
          "x-scheme-handler/ftp" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;

          "inode/directory" = fileManager;
          "application/zip" = fileManager;

          "audio/mpeg" = player;
          "audio/aac" = player;
          "audio/flac" = player;
          "audio/wav" = player;
          "video/mp4" = player;
          "video/vnd.mpegurl" = player;
          "video/x-matroska" = player;
          "application/x-mpegURL" = player;

          "image/gif" = viewer;
          "image/jpeg" = viewer;
          "image/png" = viewer;
          "image/webp" = viewer;
        };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      desktop = "${config.home.homeDirectory}/Desktop";
      videos = "${config.home.homeDirectory}/Videos";
      pictures = "${config.home.homeDirectory}/Pictures";
      music = "${config.home.homeDirectory}/Music";
      templates = "${config.home.homeDirectory}/.local/share/templates";
      publicShare = "${config.home.homeDirectory}/.local/share/public";
    };

    configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --enable-features=UseOzonePlatform
      --ozone-platform-hint=wayland
      --disable-gpu-compositing
    '';

  };

  home.packages = with pkgs; [
    swaybg
    lswt
    wlr-randr
    inputs.dvd-zig.packages."${pkgs.system}".dvd-zig

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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
    #".config/hypr".source = ./dots/hypr;
    #".config/eww/eww.yuck".source = ./dots/eww/eww.yuck;
    #".config/eww/scripts".source = ./dots/eww/scripts;
    ".config/waybar".source = ./dots/waybar;
    ".config/doom".source = ../../universal/dots/doom;
    ".config/river".source = ./dots/river;
    ".config/hypr/hyprlock.conf".source = ../../universal/dots/hypr/hyprlock.conf;
    ".config/hypr/hypridle.conf".source = ../../universal/dots/hypr/hypridle.conf;
    ".config/kitty".source = ../../universal/dots/kitty;
    ".config/zsh".source = ../../universal/dots/zsh;
    ".config/nvim".source = ../../universal/dots/nvim;
    "Pictures/Wallpapers".source = ../../universal/wallpapers;
    #".local/share/icons/oreo_purple_cursors".source = ../../universal/cursors/oreo_purple_cursors;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mrfluffy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "river";
    XDG_SESSION_DESKTOP = "river";
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORMTHEME = "qt6ct";
    WLR_DRM_NO_ATOMIC = 1;
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    OLLAMA_HOST = "0.0.0.0";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
