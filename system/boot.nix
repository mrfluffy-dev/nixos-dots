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

    plymouth = {
      enable = true;
      themePackages = [
        pkgs.plymouth-matrix-theme
      ];
      theme = "matrix";
    };
  };
}
