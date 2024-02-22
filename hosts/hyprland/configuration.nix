# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules=["amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "video=DP-1:2560x1440@144"
    "video=HDMI-A-2:1920x1080@60"
  ];
  #boot.kernelParams = ["ipv6.disable=1"];

  networking.hostName = "mrfluffyPC"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  #networking.enableIPv6 = false;
  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
    ];
  };



  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  programs.hyprland = {
	  enable = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware stuff
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
     rocmPackages.rocm-runtime
     rocmPackages.clr.icd #following for GPU AI acceleration
     rocmPackages.rocm-smi
     rocmPackages.clr
     rocmPackages.hipblas
     rocmPackages.rocblas
     rocmPackages.rocsolver
     rocmPackages.rocm-comgr
     rocmPackages.rocsparse
     rocm-opencl-icd
     rocm-opencl-runtime
     libva
     vaapiVdpau
     libvdpau-va-gl
    ];
  };
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
 # hardware.pulseaudio = {
 #   package = pkgs.pulseaudioFull;
 # };
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };

  programs.virt-manager.enable = true;
  programs.zsh.enable = true;
  programs.corectrl.enable = true;
  programs.steam = {
  enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrfluffy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel""networkmanager""video""render""docker""libvirt" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

    ];
  };
  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "mrfluffy" = import ./home.nix;
    };
  };
  fonts.packages = with pkgs; [
    ubuntu_font_family
    siji
    unifont
    noto-fonts
    source-han-code-jp
    source-han-sans
  ];

  nixpkgs.overlays = [
    (self: super: {

      mpv = super.wrapMpv (
	super.mpv.unwrapped.override { sixelSupport = true;  
      })
       {
	scripts = [ self.mpvScripts.mpris ];
       };
    })
  ];


  nixpkgs.config = {
    allowUnfree = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wl-clipboard
    bat
    socat
    eza
    wget
    foot
    spaceship-prompt
    git
    bitwarden
    zip
    xclip
    fd
    fzf
    zotero
    jdk11
    hunspell
    hunspellDicts.en_US
    pavucontrol
    zoxide
    xcp
    polkit_gnome
    unzip
    rocmPackages.rccl
    ffmpeg 
    libva-utils
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };


  services.gvfs.enable = true;
  services.resolved.enable = true;
  virtualisation.docker={
	enable = true;
	storageDriver = "btrfs";
  };
  virtualisation.libvirtd.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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

