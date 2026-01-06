{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
    };

    #settings = {
    #  theme = "dark";
    #  dynamicTheming = true;
    #  # Add any other settings here
    #};
  };
}
