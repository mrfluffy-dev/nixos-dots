{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

{
  console.keyMap = "ie";
  i18n = lib.mkMerge [
    (lib.mkIf (systemName == "laptop") {
      defaultLocale = "en_IE.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };
      extraLocaleSettings = {
        LC_ADDRESS = "en_IE.UTF-8";
        LC_IDENTIFICATION = "en_IE.UTF-8";
        LC_MEASUREMENT = "en_IE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
        LC_NAME = "en_IE.UTF-8";
        LC_NUMERIC = "en_IE.UTF-8";
        LC_PAPER = "en_IE.UTF-8";
        LC_TELEPHONE = "en_IE.UTF-8";
        LC_TIME = "en_IE.UTF-8";
      };
    })
    (lib.mkIf (systemName == "pc") {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };
    })
  ];

}
