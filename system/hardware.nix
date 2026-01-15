{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

let
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";

  # Shared VA-API / VDPAU bits across both machines
  commonVA = with pkgs; [
    libva
    libva-vdpau-driver
    libvdpau-va-gl
  ];
in
{
  # ── Graphics ─────────────────────────────────────────────────────────────────
  hardware.graphics = lib.mkMerge [
    # Laptop: Intel stack
    (lib.mkIf isLaptop {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
      ] ++ commonVA;
    })

    # PC: AMD/ROCm stack
    (lib.mkIf isPc {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        #rocmPackages.rocm-core
        #rocmPackages.rocminfo
        #rocmPackages.rocm-runtime
        #rocmPackages.clr.icd
        #rocmPackages.rocm-smi
        #rocmPackages.clr
        ##rocmPackages.hipblas
        #rocmPackages.rocblas
        #rocmPackages.rocsolver
        #rocmPackages.rocm-comgr
        #rocmPackages.rocsparse
        # amdvlk
        # driversi686Linux.amdvlk
        # mesa
        # driversi686Linux.mesa
      ] ++ commonVA;
    })
  ];

  # ── Bluetooth ────────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;          # Enable Bluetooth support
    powerOnBoot = true;     # Power up controller on boot
    settings.General = {
      #Enable = "Source,Sink,Media,Socket";
      # Experimental = true;
    };
  };

  # ── Tablets ─────────────────────────────────────────────────────────────────
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ 
    pkgs.linux-firmware
  ];

  # ── Audio (disabled examples) ───────────────────────────────────────────────
  # sound.enable = true;
  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  # };
}
