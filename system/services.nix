{ config, lib, pkgs, systemName, ... }:

{
  ###############################################
  # Desktop & Input
  ###############################################
  services.xserver.windowManager.fvwm2.gestures = true;

  # Enable touchpad support (enabled by default in most desktop managers).
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      # horizontalScrolling = false;
    };
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  ###############################################
  # Audio / Bluetooth
  ###############################################
  services.pipewire = lib.mkMerge [
    (lib.mkIf (systemName == "laptop") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire = {
        "92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 48000 ];
          };
        };
      };
    })
    (lib.mkIf (systemName == "pc") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire = {
        "92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
            "default.clock.allowed-rates" = [ 44100 48000 96000 ];
          };
        };
      };
    })
  ];

  services.blueman.enable = true;

  ###############################################
  # Printing & Files
  ###############################################
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  ###############################################
  # Time & Power
  ###############################################
  services.automatic-timezoned.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
  };

  # Laptop-specific lid and sleep behavior
  services.logind.settings.Login = lib.mkIf (systemName == "laptop") {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };

  systemd.sleep.extraConfig = lib.mkIf (systemName == "laptop") ''
    HibernateDelaySec=120min
    SuspendState=mem
  '';

  ###############################################
  # Developer Tools & Services
  ###############################################
  # direnv speedup
  services.lorri.enable = true;

  services.emacs = {
    enable = true;
    # replace with emacs-gtk, or a version provided by the community overlay if desired.
    package = pkgs.emacs-pgtk;
  };

  #services.flatpak.enable = true;

  # Sunshine (only on PC)
  services.sunshine = lib.mkIf (systemName == "pc") {
    enable = true;
    settings = {
      sunshine_name = "nixos";
      port = 47989;
      output_name = 0;
    };
    applications = {
      apps = [
        {
          name = "Steam";
          env = {
            PATH = "$(PATH):/run/current-system/sw/bin";
          };
          output = "steam.txt";
          detached = [
            "setsid /run/current-system/sw/bin/steam steam://open/bigpicture"
          ];
          prep-cmd = [
            {
              "do" = "";
              "undo" = "setsid /run/current-system/sw/bin/steam steam://close/bigpicture";
            }
          ];
          image-path = "steam.png";
        }
      ];
    };
    capSysAdmin = false;
    openFirewall = true;
  };

  # Ollama (only on PC)
  services.ollama = lib.mkIf (systemName == "pc") {
    enable = true;
    port = 11434;
    host = "0.0.0.0";
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
    environmentVariables = {
      OLLAMA_DEBUG = "1";
      OLLAMA_MMAP = "0";
      OLLAMA_NUM_CTX = "40000";
      OLLAMA_NUM_GPU = "20";
      OLLAMA_FLASH_ATTENTION="true";
      # HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      OLLAMA_KV_CACHE_TYPE = "f16";
    };
  };

  ###############################################
  # Systemd User Services
  ###############################################
  systemd.user.services.steam-run-url-service = {
    description = "Service to launch Steam URLs via FIFO";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = let
        script = pkgs.writeShellScript "steam-run-url-service.sh" ''
          #!/usr/bin/env bash
          FIFO="/run/user/$(id --user)/steam-run-url.fifo"
          if [ ! -p "$FIFO" ]; then
            mkfifo "$FIFO"
          fi
          while true; do
            if read line <"$FIFO"; then
              steam_env=();
              if [ "$XDG_SESSION_DESKTOP" = "sway" ] || [ "$XDG_SESSION_DESKTOP" = "Hyprland" ] || [ "$DESKTOP_SESSION" = "sway" ] || [ "$DESKTOP_SESSION" = "Hyprland" ]; then
                steam_env+=("QT_QPA_PLATFORM=wayland");
              fi
              steam "$line"
            fi
          done
        '';
      in "${script}";
      Restart = "always";
    };
    path = [ pkgs.steam ];
  };

  ###############################################
  # Networking & Remote
  ###############################################
  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [ "192.168.1.180" ];
  #   dnsovertls = "true";
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  ###############################################
  # Virtualization
  ###############################################
  virtualisation.libvirtd.enable = true;

  ###############################################
  # Udev Rules
  ###############################################
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.platformio
    pkgs.openocd
    pkgs.brave
  ];

  # services.udev.extraRules = ''
  #   KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
  # '';
}
