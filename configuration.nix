# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  window_manager,
  systemName,
  ...
}:

let
  oreo = pkgs.callPackage ./personalPKGS/oreo.nix { };
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system/hardware.nix
    ./system/boot.nix
    ./system/network.nix
    ./system/inputMethods.nix
    ./system/services.nix
    ./system/fonts.nix
    ./system/nixOSPkgs.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.niri.nixosModules.niri
  ];
  # niri settings
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
  #time.timeZone = "Europe/Dublin";
  #programs.river.enable = true;
  #programs.niri.enable = true;
  #programs.niri.package = pkgs.niri-stable;
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  #programs.hyprland.enable = true;
  programs.river.enable = window_manager == "river" || window_manager == "all";
  qt.enable = true;
  #qt.style = "gtk2";
  qt.platformTheme = "qt5ct";

  xdg.menus.enable = true;
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    enable = window_manager == "niri" || window_manager == "all";
    package = pkgs.niri-stable; # Only needed if not provided by the overlay
  };

  programs.hyprland.enable = window_manager == "hyprland" || window_manager == "all";
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "ie";
      variant = "";
    };
    enable = true;
    #displayManager.lightdm = {
    #  enable = true;
    #  greeters.gtk = {
    #    enable = true;
    #    theme.package = pkgs.amarena-theme;
    #    theme.name = "amarena";
    #    cursorTheme.package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
    #    cursorTheme.name = "oreo_spark_pink_cursors";
    #    extraConfig = "background=${./assets/Wallpapers/138.png}";
    #  };
    #};
  };
  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --window-padding 1 --time --time-format '%R - %F' --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };

  security.rtkit.enable = true;
  security.polkit = {
    enable = true;
    #package = pkgs.polkit_gnome;
  };
  environment.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };
  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    #XDG_CURRENT_DESKTOP = "hyprland";
    #QT_QPA_PLATFORMTHEME = "qt6ct";
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
      "input"
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
      "input"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

    ];
  };
  users.groups.libvirtd.members = [
    "mrfluffy"
    "work"
  ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs window_manager systemName;
    };
    users = {
      "mrfluffy" = import ./home/mrfluffy.nix;

      "work" = import ./home/work.nix;
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = lib.mkIf (systemName == "pc") "btrfs";
  };
  virtualisation.libvirtd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  security.pam.services.swaylock = { };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
