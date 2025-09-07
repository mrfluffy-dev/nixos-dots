{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

let
  isLaptop = systemName == "laptop";
  isPc     = systemName == "pc";

  initrdBaseModules = [ "btusb" ];
  initrdLPModules   = [ "kvm" ];                # for laptop & pc

  kernelBaseModules = [ "v4l2loopback" ];

  kernelBaseParams  = [ ];
  kernelLPParams    = [ "ipv6e=1" ];            # for laptop & pc
  kernelLaptopOnly  = [ "i915.force_probe=46a6" ];
  kernelPcOnly      = [ "video=2560x1440x32" ];
in
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.kernelModules = lib.mkMerge [
      initrdBaseModules
      (lib.mkIf (isLaptop || isPc) initrdLPModules)
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules  = kernelBaseModules;

    extraModulePackages = [
      pkgs.linuxPackages_latest.v4l2loopback
    ];

    kernelParams = lib.mkMerge [
      (lib.mkIf (isLaptop || isPc) kernelLPParams)
      (lib.mkIf isLaptop kernelLaptopOnly)
      (lib.mkIf isPc     kernelPcOnly)
    ];

    extraModprobeConfig = ''
      options v4l2loopback devices=2 video_nr=1,0 card_label="OBS Cam","phone cam" exclusive_caps=1,1
    '';

    plymouth = {
      enable = false;
      themePackages = [ pkgs.plymouth-matrix-theme ];
      theme = "matrix";
    };
  };
}
