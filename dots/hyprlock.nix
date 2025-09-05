{
  config,
  lib,
  pkgs,
  inputs,
  systemName,
  ...
}:

{
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${lib.getExe pkgs.hyprlock}";
          unlock_cmd = "killall -s SIGUSR1 hyprlock";
          before_sleep_cmd = "loginctl lock-session && sleep 1.5";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
        ]
        ++ lib.optional (systemName == "laptop") {
          timeout = 700;
          on-timeout = "hyprctl dispatch dpms off";  # Turns off all displays
          on-resume = "hyprctl dispatch dpms on";   # Turns displays back on
        }
        ++ lib.optional (systemName == "laptop") {
          timeout = 800;
          on-timeout = "systemctl suspend-then-hibernate";
        }
        ++ lib.optional (systemName == "pc") {
          timeout = 700;  # Adjust timeout as needed (in seconds)
          on-timeout = "hyprctl dispatch dpms off";  # Turns off all displays
          on-resume = "hyprctl dispatch dpms on";   # Turns displays back on
        };
      };
    };
  };
  systemd.user.services.hypridle = lib.mkForce {
    Unit = {
      Description = "hypridle";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      # Remove ConditionEnvironment, handle in ExecStart or ensure variable is imported
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.hypridle}";
      Restart = "always";
      RestartSec = "10s";
      # Check inside the service if needed
      ExecStartPre = "/bin/sh -c 'test -n \"$WAYLAND_DISPLAY\"'";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        background = {
          path = "${../assets/Wallpapers/138.png}"; # only png supported for now
          color = "rgba(25, 20, 20, 1.0)";

          # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
          blur_passes = 0; # 0 disables blurring
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };
        input-field = {
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false;
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        };
        label = {
          text = "Hi there, $USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          font_family = "Noto Sans";
          position = "0, 80";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
