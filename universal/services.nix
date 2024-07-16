{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 200000;
        "defautlt.allowed-rates" = [ 200000 ];
        #"default.clock.quantum" = 1024;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 8192;
      };
    };
  };
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List services that you want to enable:
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };

  services.ollama = {
    enable = true;
    port = 11434;
    host = "0.0.0.0";
    acceleration = "rocm";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };
  services.gvfs.enable = true;
  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [ "192.168.1.180" ];
  #   dnsovertls = "true";
  # };

  virtualisation.libvirtd.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #udev rules
  #services.udev.extraRules = ''
  # KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
  #'';

}
