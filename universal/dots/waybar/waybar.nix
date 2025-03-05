{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    style = ''
      #tags button {
          padding: 0 5px;
          color: #f8f8f2;
      }

      #tags button.occupied {
        color: inherit;
        background-color: #6a548d
      }



      #tags button.focused {
          color: #f8f8f2;
          background-color: #aa86e1 ;
      }

      #tags button.urgent {
        color: #ea6962;
      }

      #mode {
          background: #64727D;
          border-bottom: 3px solid #f8f8f2;
      }

    '';

    settings = {
      mainBar = {
        layer = "top"; # Waybar at top layer
        # position= "bottom", # Waybar position (top|bottom|left|right)
        height = 30; # Waybar height (to be removed for auto height)
        #width = 1280; # Waybar width
        spacing = 4; # Gaps between modules (4px)
        # Choose the order of the modules
        modules-left = [
          "river/tags"
          "custom/media"
        ];
        modules-center = [ ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "tray"
        ];
        # Modules configuration
        "hyprland/workspaces" = {
          format = "{icon}";
          on_click = "activate";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
          };
          "persistent-workspaces" = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
          };
          active-only = false;
          sort-by-name = true;
          all-outputs = true;
        };
        "river/tags" = {
          num-tags = 9;
          tag-labels = [
            "一"
            "二"
            "三"
            "四"
            "五"
            "六"
            "七"
            "八"
            "九"
          ];
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          #"icon-size": 21,
          spacing = 10;
        };
        clock = {
          # "timezone": "America/New_York",
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };

        network = {
          interface = "enp7s0"; # (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 囹";
          tooltip-format = "{ifname} via {gwaddr} 囹";
          format-linked = "{ifname} (No IP) 囹";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          # "scroll-step": 1, // %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
}
