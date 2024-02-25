{ config, lib, pkgs, ... }:

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
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List services that you want to enable:
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };

  services.ollama = {
    enable = true;
    listenAddress = "0.0.0.0:11434";
    package = (pkgs.ollama.override {  enableRocm = true; });
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

}
