{
  config,
  lib,
  pkgs,
  window_manager,
  inputs,
  ...
}:

{
  xdg = {
    enable = true;

    portal = {
      enable = true;

      config.common.default = [
        "hyprland;kde"
        "river"
        "kde"
        "gtk"
      ];

      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        kdePackages.xdg-desktop-portal-kde
      ];
    };

    mime.enable = true;

    mimeApps = {
      enable = true;

      defaultApplications =
        let
          browser     = [ "brave.desktop" ];
          fileManager = [ "pcmanfm.desktop" ];
          editor      = [ "emacs.desktop" ];
          player      = [ "mpv.desktop" ];
          viewer      = [ "imv-dir.desktop" ];
          reader      = [ "org.pwmt.zathura.desktop" ];
        in {
          # Documents
          "application/pdf"  = reader;
          "application/epub" = reader;

          # Text / markup
          "text/plain"                  = editor;
          "application/x-wine-extension-ini" = editor;
          "text/html"                   = browser;
          "text/xml"                    = browser;

          # Web / XML-ish
          "application/json"            = browser;
          "application/xml"             = browser;
          "application/xhtml+xml"       = browser;
          "application/xhtml_xml"       = browser;
          "application/rdf+xml"         = browser;
          "application/rss+xml"         = browser;
          "application/x-extension-htm"   = browser;
          "application/x-extension-html"  = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xht"   = browser;
          "application/x-extension-xhtml" = browser;

          # URL schemes
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/ftp"   = browser;
          "x-scheme-handler/http"  = browser;
          "x-scheme-handler/https" = browser;

          # Files / directories
          "inode/directory" = fileManager;
          "application/zip" = fileManager;

          # Audio
          "audio/mpeg" = player;
          "audio/aac"  = player;
          "audio/flac" = player;
          "audio/wav"  = player;

          # Video
          "video/mp4"           = player;
          "video/vnd.mpegurl"   = player;
          "video/x-matroska"    = player;
          "application/x-mpegURL" = player;

          # Images
          "image/gif"  = viewer;
          "image/jpeg" = viewer;
          "image/png"  = viewer;
          "image/webp" = viewer;
        };
    };

    userDirs = {
      enable = true;
      createDirectories = true;

      download    = "${config.home.homeDirectory}/Downloads";
      documents   = "${config.home.homeDirectory}/Documents";
      desktop     = "${config.home.homeDirectory}/Desktop";
      videos      = "${config.home.homeDirectory}/Videos";
      pictures    = "${config.home.homeDirectory}/Pictures";
      music       = "${config.home.homeDirectory}/Music";
      templates   = "${config.home.homeDirectory}/.local/share/templates";
      publicShare = "${config.home.homeDirectory}/.local/share/public";
    };

    configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --enable-features=UseOzonePlatform
      --ozone-platform-hint=wayland
    '';

    # Example:
    # configFile."hypr/hyprland.conf".onChange = "hyprctl reload";
  };
}
