{
  config,
  lib,
  pkgs,
  inputs,
  window_manager,
  ...
}:

{
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
}
