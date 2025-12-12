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

{
  imports = [
    ./hardware-configuration.nix
    ./system/boot.nix
    ./system/network.nix
    ./system/inputMethods.nix
    ./system/hardware.nix
    ./system/fonts.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.jovian.nixosModules.default
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
  # Users
  ##############################################################################
  programs.zsh.enable = true;
  users = {
    users = {
      mrfluffy = {
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
          "seat"
        ];
        packages = with pkgs; [ ];
      };

      work = {
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
          "seat"
        ];
        packages = with pkgs; [ ];
      };
      game = {
        isNormalUser = true;
        description = "Dedicated gaming user (auto-login in Steam specialisation)";
        shell = pkgs.bash;
        createHome = true;
        password = ""; # no password
        extraGroups = [
          "wheel"
          "video"
          "render"
          "input"
          "seat"
          "networkmanager"
        ];
        home = "/home/game";
      };
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
      game = import ./home/game.nix;
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
  # Nixpkgs policy
  ##############################################################################
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  ##############################################################################
  # decky
  ##############################################################################
  nixpkgs.overlays = [
    inputs.jovian.overlays.default
  ];
  jovian.decky-loader = {
    enable = true;
    user = "game"; # Run as your gaming user
    stateDir = "/home/game/.local/share/decky"; # Store plugins/data in user's home (adjust if preferred)
    # Optional: Add extra packages if needed for specific plugins
    # extraPackages = with pkgs; [ some-package ];
    # extraPythonPackages = ps: with ps; [ some-python-package ];
  };

  ##############################################################################
  # State version
  ##############################################################################
  system.stateVersion = "24.11"; # Did you read the comment?

  specialisation = {
    "01-steam" = {
      configuration = {
        imports = [
          ./system/specialisation/steam.nix
        ];
      };
    };

    "00-main-system" = {
      configuration = {
        #boot.loader.systemd-boot.sortKey = lib.mkDefault "00000000000-main";
        ##############################################################################
        # Imports
        ##############################################################################
        imports = [
          ./system/services.nix
          ./system/nixOSPkgs.nix
          ./system/specialisation/main-system.nix
          #inputs.niri.nixosModules.niri
        ];
      };
    };
  };
}
