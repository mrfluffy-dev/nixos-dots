{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
    };

    default.settings = {
      theme = "dark";
      dynamicTheming = true;
      # Add any other settings here
    };
  };
}
