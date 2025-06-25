{
  config,
  lib,
  pkgs,
  inputs,
  window_manager,
  ...
}:
let
  quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  systemd.user.services.quickshell = lib.mkIf (window_manager == "hyprland") {
    Unit = {
      Description = "QuickShell Application";
      After = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${quickshellPackage}/bin/quickshell";
      ExecStartPre = "/bin/sh -c 'test -n \"$WAYLAND_DISPLAY\"'";
      Restart = "always";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
