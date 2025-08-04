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
  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Ulauncher service";
      Documentation = [ "https://ulauncher.io/" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      BusName = "io.ulauncher.Ulauncher";
      Environment="GDK_BACKEND=x11";
      ExecStart = "${lib.getExe pkgs.ulauncher} --hide-window";
      Restart = "always";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
