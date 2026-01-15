{
  config,
  lib,
  pkgs,
  inputs,
  window_manager,
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
        background-color: #6a548d;
      }

      #tags button.focused {
          color: #f8f8f2;
          background-color: #aa86e1;
      }

      #tags button.urgent {
        color: #ea6962;
      }

      #mode {
          background: #64727D;
          border-bottom: 3px solid #f8f8f2;
      }
      #backlight-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
      }
      #backlight-slider trough {
          min-height: 10px;
          min-width: 10px;
          border-radius: 5px;
          background-color: black;
      }
      #backlight-slider highlight {
          min-width: 100px;
          border-radius: 5px;
          background-color: red;
      }
      /* Add divider styling */
      #custom-divider {
        color: #6a548d;
        padding: 0 5px;
      }


      /* --------------------------
         Workspaces styling
         -------------------------- */


      #workspaces button {
          padding: 0 6px;
          font-size: 0.9em;
          color: #f8f8f2;
          background: transparent;
          border: none;
          border-radius: 3px;
          transition: background 0.2s ease, color 0.2s ease;
      }

      #workspaces button.empty {
          opacity: 0.5;
      }

      #workspaces button.persistent {
          background-color: #44475a;
      }

      #workspaces button.special {
          background-color: #8bd49e;
          color: #282a36;
      }

      #workspaces button.visible {
          background-color: #aa86e1;
      }

      #workspaces button.active {
          background-color: #6a548d;
      }

      #workspaces button.urgent {
          color: #ea6962;
          font-weight: bold;
      }

      #workspaces button.hosting-monitor {
          box-shadow: 0 0 0 1px #f8f8f2 inset;
      }

      #workspaces button:hover {
          background-color: rgba(255, 255, 255, 0.1);
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
        modules-left =
          if window_manager == "river"
          then [
            "river/tags"
            "custom/media"
          ]
          else if window_manager == "hyprland"
          then [
            "hyprland/workspaces"
          ]
          else [ ];
        modules-center = [
        ];

        modules-right = [
          "pulseaudio"
          "custom/divider"
          "network"
          "custom/divider"
          "cpu"
          "custom/divider"
          "memory"
          "custom/divider"
          "power-profiles-daemon"
          "custom/divider"
          "battery"
          "custom/divider"
          "backlight"
          "custom/divider"
          "clock"
          "custom/divider"
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
            "10" = "일";
            "11" = "이";
            "12" = "삼";
            "13" = "사";
            "14" = "오";
            "15" = "육";
            "16" = "칠";
            "17" = "팔";
            "18" = "구";

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
        battery = {
          bat = "BAT0";
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };
        "backlight/slider" = {
          min = 0;
          max = 400;
          orientation = "horizontal";
          device = "intel_backlight";
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          tooltip-format = "Backlight is {percent}% {icon}";
          format-icons = [
            "☽"
            ""
            ""
          ];
        };
        tray = {
          #"icon-size": 21,
          spacing = 10;
        };
        #clock = {
        #  # "timezone": "America/New_York",
        #  tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        #  format-alt = "{:%Y-%m-%d}";
        #};
        "clock" = {
          format = "{:%r}  ";
          format-alt = "{:%A, %B %d, %Y (%R)}  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          interval = 1;
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            "on-click-right" = "mode";
            #"on-scroll-up" = "tz_up";  # Note: There's a duplicate "on-scroll-up" here
            #"on-scroll-down" = "tz_down";  # And duplicate "on-scroll-down"
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };

        network = {
          interface = "wlo1"; # (Optional) To force the use of this interface
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
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        # Add this new module definition
        "custom/divider" = {
          format = "│";
          interval = "once";
          tooltip = false;
        };
      };
    };
  };
}
