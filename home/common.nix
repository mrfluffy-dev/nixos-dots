{
  config,
  lib,
  pkgs,
  inputs,
  window_manager,
  ...
}:

{
  imports = [
    # Core theming & integrations
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    inputs.nixcord.homeModules.nixcord
    inputs.niri.homeModules.niri

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
    ../dots/xdg.nix
    ../dots/hyprland.nix
    ../dots/niri.nix
    ../dots/hyprpaper.nix
    ../dots/caelestia.nix
    ../dots/dankMeterialShell.nix
  ];

  # Common state version
  home.stateVersion = "23.11";

  # Common GTK settings
  #gtk = {
  #  enable = true;
  #  iconTheme = {
  #    name = "Reversal-black-dark";
  #    package = pkgs.reversal-icon-theme.override { allColorVariants = true; };
  #  };
  #};

  # Common packages for all users
  home.packages = with pkgs; [
    lswt
    swaybg
    wlr-randr
  ];

  # Common dotfiles
  home.file = {
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
    ".config/doom".source = ../dots/doom;
    "Pictures/Wallpapers".source = ../assets/Wallpapers;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
