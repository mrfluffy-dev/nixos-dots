{
  config,
  pkgs,
  inputs,
  lib,
  window_manager,
  ...
}:
let
in
{
  imports = [
    # Core theming & apps
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    inputs.nixcord.homeModules.nixcord
    # inputs.niri.homeModules.niri

    # Local modules
    ./sessionVars.nix
    ./stylix.nix
    ./homePkgs.nix
    ./services.nix

    # Dots
    ../dots/foot.nix
    ../dots/waybar.nix
    ../dots/zsh.nix
    ../dots/nixcord.nix
    #../dots/hyprlock.nix
    ../dots/xdg.nix
    ../dots/river.nix
    ../dots/niri.nix
    ../dots/hyprland.nix
    ../dots/hyprpaper.nix
  ];

  # You can find color schemes at: https://github.com/tinted-theming/schemes
  colorScheme = inputs.nix-colors.colorSchemes.blueish;
  stylix.base16Scheme.base00 = "0F1417";

  # Home Manager user information
  home.username = "work";
  home.homeDirectory = "/home/work";

  # This determines compatibility with a specific Home Manager release.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Example GTK block (disabled)
  # gtk = {
  #   enable = true;
  #   iconTheme = {
  #     name = "Dracula";
  #     # package = pkgs.dracula-icon-theme;
  #   };
  # };

  home.packages = with pkgs; [
    ############################
    # Wayland / Desktop tools
    ############################
    lswt
    swaybg
    wlr-randr

    ############################
    # Browsers
    ############################
    brave

    # swaynotificationcenter
    # inputs.ladybird.packages."${pkgs.system}".ladybird

    # pkgs.hello
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Dotfiles & static files managed by Home Manager
  home.file = {
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
    ".config/doom".source = ../dots/doom;
    # ".config/quickshell".source = ../dots/shell;
    # ".config/kitty".source = ../../universal/dots/kitty;
    # ".config/nvim".source = ../../universal/dots/nvim;
    "Pictures/Wallpapers".source = ../assets/Wallpapers;

    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # If you don't manage your shell with Home Manager, remember to source:
  # ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # /etc/profiles/per-user/mrfluffy/etc/profile.d/hm-session-vars.sh

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
