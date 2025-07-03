{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = lib.mkMerge [
      (lib.mkIf (systemName == "laptop") [
        "kvm"
      ])
      (lib.mkIf (systemName == "pc") [
        "amdgpu"
        "kvm"
      ])
    ];

    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ pkgs.linuxPackages_zen.v4l2loopback ];
    kernelParams = lib.mkMerge [
      (lib.mkIf (systemName == "laptop") [
        "ipv6e=1"
        "i915.force_probe=46a6"
      ])
      (lib.mkIf (systemName == "pc") [
        "video=2560x1440x32"
        "ipv6e=1"
      ])
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=2 video_nr=1,0 card_label="OBS Cam","phone cam" exclusive_caps=1,1
    '';

    plymouth = {
      enable = true;
      themePackages = [
        pkgs.plymouth-matrix-theme
      ];
      theme = "matrix";
    };
  };
}
