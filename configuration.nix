# Edit this configuration file to define what should be installed on
# your system. Help is available in configuration.nix(5) and via `nixos-help`.

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

  # Window manager toggles
  wmAll = window_manager == "all";
  useRiver = window_manager == "river" || wmAll;
  useNiri = window_manager == "niri" || wmAll;
  useHypr = window_manager == "hyprland" || wmAll;
in
{
  ##############################################################################
  # Imports
  ##############################################################################
  imports = [
    ./hardware-configuration.nix
    ./system/hardware.nix
    ./system/boot.nix
    ./system/network.nix
    ./system/inputMethods.nix
    ./system/services.nix
    ./system/fonts.nix
    ./system/nixOSPkgs.nix
    inputs.home-manager.nixosModules.home-manager
    #inputs.niri.nixosModules.niri
  ];

  ##############################################################################
  # Nix settings
  ##############################################################################
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    build-dir = "/nix/var/nix/builds";
    auto-optimise-store = true;
  };

  ##############################################################################
  # Desktop / WM
  ##############################################################################
  programs.river-classic.enable = useRiver;

  qt = {
    enable = true;
    # style = "gtk2";
    platformTheme = "qt5ct";
  };

  xdg.menus.enable = true;

  # Work around Dolphin menu oddities: force Plasma menu definition
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Niri (via overlay)
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  #programs.niri = {
  #  enable = useNiri;
  #  package = pkgs.niri-stable; # Only needed if not provided by the overlay
  #};

  # Hyprland
  programs.hyprland = {
    enable = useHypr;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # X11 base (kept enabled for keymap + DM if needed)
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ie";
      variant = "";
    };

    # displayManager.lightdm = {
    #   enable = true;
    #   greeters.gtk = {
    #     enable = true;
    #     theme.package = pkgs.amarena-theme;
    #     theme.name = "amarena";
    #     cursorTheme.package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
    #     cursorTheme.name = "oreo_spark_pink_cursors";
    #     extraConfig = "background=${./assets/Wallpapers/138.png}";
    #   };
    # };
  };

  # greetd + tuigreet
  services.greetd = {
    enable = true;
    restart = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --window-padding 1 --time --time-format '%R - %F' --remember --remember-session --asterisks";
      user = "greeter";
    };
  };

  ##############################################################################
  # Security / PolicyKit / PAM
  ##############################################################################
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      swaylock = { };
      greetd.enableGnomeKeyring = true;
      greetd.kwallet.enable = true;
    };
  };

  ##############################################################################
  # Environment
  ##############################################################################
  environment = {
    sessionVariables = {
      ZDOTDIR = "$HOME/.config/zsh";
    };
    pathsToLink = [ "/share/zsh" ];
    variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = "radeonsi";
      # AMD_VULKAN_ICD = "RADV";
      # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      # XDG_CURRENT_DESKTOP = "hyprland";
      # QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    systemPackages = with pkgs; [
      vim
      wget
      neovim
    ];
  };

  ##############################################################################
  # Users
  ##############################################################################
  users = {
    users.mrfluffy = {
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
      ];
      packages = with pkgs; [ ];
    };

    users.work = {
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
      ];
      packages = with pkgs; [ ];
    };

    groups.libvirtd.members = [
      "mrfluffy"
      "work"
    ];
  };

  ##############################################################################
  # Home-Manager
  ##############################################################################
  home-manager = {
    extraSpecialArgs = { inherit inputs window_manager systemName; };
    users = {
      mrfluffy = import ./home/mrfluffy.nix;
      work = import ./home/work.nix;
    };
  };

  ##############################################################################
  # Virtualisation
  ##############################################################################
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = lib.mkIf (systemName == "pc") "btrfs";
    };
    libvirtd.enable = true;
  };

  ##############################################################################
  # Nixpkgs policy
  ##############################################################################
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  ##############################################################################
  # State version
  ##############################################################################
  system.stateVersion = "24.11"; # Did you read the comment?
}
