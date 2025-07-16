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
            "default.clock.allowed-rates" = [
              44100
              48000
              96000
            ];
          };
        };
        #"93-mic-gain" = {
        #  "context.modules" = [
        #    {
        #      name = "libpipewire-module-filter-chain";
        #      args = {
        #        node.description = "Mic Gain Boost";
        #        media.name = "Mic Gain Boost";
        #        filter.graph = {
        #          nodes = [
        #            {
        #              type = "ladspa";
        #              name = "gain";
        #              plugin = "amp";  # LADSPA amplifier plugin
        #              label = "amp_mono";
        #              control = {
        #                "Gain" = 12.0;  # Boost gain by 12 dB (adjust as needed)
        #              };
        #            }
        #          ];
        #        };
        #        capture.props = {
        #          "node.name" = "effect_input.mic_boost";
        #          "audio.position" = [ "MONO" ];
        #        };
        #        playback.props = {
        #          "node.name" = "effect_output.mic_boost";
        #          "audio.position" = [ "MONO" ];
        #        };
        #      };
        #    }
        #  ];
        #};
      };
      #wireplumber.extraConfig = {
      #  "monitor.alsa.rules" = {
      #    rule1 = {  # Give the rule a unique name
      #      matches = [
      #        { "node.name" = "~alsa_input.*"; }
      #      ];
      #      actions = {
      #        update-props = {
      #          "api.alsa.soft-mixer" = true;
      #          "api.alsa.volume" = "100%";
      #          "api.alsa.headroom" = 0;
      #        };
      #      };
      #    };
      #  };
      #};
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
    package = pkgs.emacs-pgtk; # replace with emacs-gtk, or a version provided by the community overlay if desired.
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
