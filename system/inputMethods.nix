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
in
{
  # Set console keymap based on systemName
  console.keyMap =
    if isLaptop
    then "ie"
    else "us";

  # Locale settings
  i18n.defaultLocale =
    if isLaptop
    then "en_IE.UTF-8"
    else "en_US.UTF-8";

  i18n.extraLocaleSettings =
    let
      locale =
        if isLaptop
        then "en_IE.UTF-8"
        else "en_US.UTF-8";
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
