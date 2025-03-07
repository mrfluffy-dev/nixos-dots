# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  oreo = pkgs.callPackage ../../universal/personalPKGS/oreo.nix { };
in
{
  imports = [
    # Include the results of the hardware scan.
    ../../hardware-configuration.nix
    ../../universal/nixOSPkgs.nix
    ../../universal/hardware.nix
    ../../universal/boot.nix
    ../../universal/network.nix
    ../../universal/services.nix
    ../../universal/fonts.nix
    ../../universal/inputMethods.nix
    #./stylixsys.nix
    #inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    #XDG_CURRENT_DESKTOP = "hyprland";
    #QT_QPA_PLATFORMTHEME = "qt6ct";
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      build-dir = "/var/tmp";
      auto-optimise-store = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  #
  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
        theme.package = pkgs.amarena-theme;
        theme.name = "amarena";
        cursorTheme.package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
        cursorTheme.name = "oreo_spark_pink_cursors";
        extraConfig = "background=${../../universal/wallpapers/138.png}";
      };
    };
  };
  #xdg.portal = {
  #  enable = true;
  #  wlr.enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-gtk
  #    pkgs.xdg-desktop-portal-wlr
  #  ];
  #};
  security.rtkit.enable = true;
  environment.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrfluffy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "docker"
      "libvirt"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

    ];
  };

  users.users.work = {
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "docker"
      "libvirt"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "mrfluffy" = import ./home.nix;

      #"work" = import ./home-work.nix;
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
  virtualisation.libvirtd.enable = true;

  security.pam.services.swaylock = { };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
