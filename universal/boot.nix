{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" "kvm" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams =
    [ "video=DP-1:2560x1440@144" "video=HDMI-A-2:1920x1080@60" "ipv6e=1" ];
  boot.plymouth.enable = true;
}
