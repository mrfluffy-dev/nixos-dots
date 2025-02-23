{
  config,
  lib,
  pkgs,
  ...
}:

{
  # hardware stuff
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.rocm-runtime
      rocmPackages.clr.icd # following for GPU AI acceleration
      rocmPackages.rocm-smi
      rocmPackages.clr
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.rocsolver
      rocmPackages.rocm-comgr
      rocmPackages.rocsparse
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
      #Experimental = true;
    };
  };
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  # Enable sound.
  # sound.enable = true;
  #hardware.pulseaudio = {
  #  enable = true;
  #  package = pkgs.pulseaudioFull;
  #};

}
