{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:

{

  services.xserver.windowManager.fvwm2.gestures = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # power managment
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  #

  services.flatpak.enable = true;
  services.automatic-timezoned.enable = true;
  services.pipewire = lib.mkMerge [
    (lib.mkIf (systemName == "laptop") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire = {
        # the key "00-clock-rate" names the drop-in file
        "00-clock-rate" = {
          # these properties go under [context.properties] in pipewire.conf
          context.properties = {
            # force the graph sample rate
            "default.clock.rate" = 48000;
            # tell PipeWire which other rates you allow it to switch to
            "default.clock.allowed-rates" = [
              44100
              48000
              96000
            ];
            # quantum = number of frames per period (i.e. buffer size)
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 8192;
          };
        };
        "99-input-denoising" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-filter-chain";
              "args" = {
                "node.description" = "Noise Canceling source";
                "media.name" = "Noise Canceling source";
                "filter.graph" = {
                  "nodes" = [
                    {
                      "type" = "ladspa";
                      "name" = "rnnoise";
                      "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                      "label" = "noise_suppressor_mono";
                      "control" = {
                        "VAD Threshold (%)" = 20.0;
                        "VAD Grace Period (ms)" = 200;
                        "Retroactive VAD Grace (ms)" = 0;
                      };
                    }
                  ];
                };

                "capture.props" = {
                  "node.name" = "effect_input.rnnoise";
                  "node.passive" = true;
                  "audio.rate" = 48000;
                };
                "playback.props" = {
                  "node.name" = "effect_output.rnnoise";
                  "media.class" = "Audio/Source";
                  "audio.rate" = 48000;
                };
              };
            }
          ];
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
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 48000 ];
          };
        };
        "99-input-denoising" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-filter-chain";
              "args" = {
                "node.description" = "Noise Canceling source";
                "media.name" = "Noise Canceling source";
                "filter.graph" = {
                  "nodes" = [
                    {
                      "type" = "ladspa";
                      "name" = "rnnoise";
                      "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                      "label" = "noise_suppressor_mono";
                      "control" = {
                        "VAD Threshold (%)" = 50.0;
                        "VAD Grace Period (ms)" = 200;
                        "Retroactive VAD Grace (ms)" = 0;
                      };
                    }
                  ];
                };

                "capture.props" = {
                  "node.name" = "effect_input.rnnoise";
                  "node.passive" = true;
                  "audio.rate" = 48000;
                };
                "playback.props" = {
                  "node.name" = "effect_output.rnnoise";
                  "media.class" = "Audio/Source";
                  "audio.rate" = 48000;
                };
              };
            }
          ];
        };
      };

    })
  ];

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      #horizontalScrolling = false;
    };
  };
  # List services that you want to enable:
  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };
  services.sunshine = lib.mkIf (systemName == "pc") {
    enable = true;
    settings = {
      sunshine_name = "nixos";
      port = 47989;
    };
    applications = {
      apps = [
        {
          name = "Steam";
          output = "steam.txt";
          detached = [ "${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/gamepadui" ];
          image-path = "steam.png";
        }
      ];
    };
    capSysAdmin = true;
    openFirewall = true;
  };

  services.ollama = lib.mkIf (systemName == "pc") {
    enable = true;
    port = 11434;
    host = "0.0.0.0";
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
    environmentVariables = {
      #HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      #OLLAMA_KV_CACHE_TYPE = "q4";
    };
  };

  services.gvfs.enable = true;
  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [ "192.168.1.180" ];
  #   dnsovertls = "true";
  # };

  virtualisation.libvirtd.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # laptop screen lid colose stuff
  services.logind = lib.mkIf (systemName == "laptop") {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
  };
  #suspend stuff
  systemd.sleep.extraConfig = lib.mkIf (systemName == "laptop") ''
    HibernateDelaySec=120min
    SuspendState=mem
  '';
  #udev rules
  #services.udev.extraRules = ''
  # KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
  #'';

}
