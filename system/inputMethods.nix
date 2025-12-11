{ config, lib, pkgs, systemName, ... }:

{
  # Set console keymap based on systemName
  console.keyMap = if systemName == "laptop" then "ie" else "us";

  # Locale settings
  i18n.defaultLocale =
    if systemName == "laptop"
    then "en_IE.UTF-8"
    else "en_US.UTF-8";

  i18n.extraLocaleSettings = let
    locale = if systemName == "laptop" then "en_IE.UTF-8" else "en_US.UTF-8";
  in {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };
}
