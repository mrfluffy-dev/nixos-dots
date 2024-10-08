{ config, pkgs, inputs, ... }:
let
  #hyprlock = pkgs.callPackage ../../universal/personalPKGS/hyprlock.nix {};
  #hypridle = pkgs.callPackage ../../universal/personalPKGS/hypridle.nix {};
in {
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
  home.username = "work";
  home.homeDirectory = "/home/work";

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

  home.packages = with pkgs; [
    tenv
    swaybg
    lswt
    wlr-randr
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
    #".config/hypr".source = ./dots/hypr;
    #".config/eww/eww.yuck".source = ./dots/eww/eww.yuck;
    #".config/eww/scripts".source = ./dots/eww/scripts;
    ".config/waybar".source = ./dots/waybar;
    ".config/doom".source = ../../universal/dots/doom;
    ".config/river".source = ./dots/river;
    ".config/hypr/hyprlock.conf".source =
      ../../universal/dots/hypr/hyprlock.conf;
    ".config/hypr/hypridle.conf".source =
      ../../universal/dots/hypr/hypridle.conf;
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
