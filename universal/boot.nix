{
  config,
  lib,
  pkgs,
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
    initrd.kernelModules = [
      "amdgpu"
      "kvm"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "video=2560x1440x32"
      "ipv6e=1"
    ];
    plymouth = {
      enable = true;
      themePackages = [
        pkgs.plymouth-matrix-theme
      ];
      theme = "matrix";
    };
  };
}
