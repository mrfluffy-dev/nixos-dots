{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

{
  # hardware stuff
  hardware.graphics = lib.mkMerge [
    (lib.mkIf (systemName == "laptop") {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
        libva
        vaapiVdpau
        libvdpau-va-gl
      ];
    })
    (lib.mkIf (systemName == "pc") {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.rocm-core
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime
        rocmPackages.clr.icd
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
        amdvlk
        driversi686Linux.amdvlk
      ];
    })
  ];

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
