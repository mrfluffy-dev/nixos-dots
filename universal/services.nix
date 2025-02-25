{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 200000;
          "default.clock.allowed-rates" = [ 200000 ];
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
                      "VAD Threshold (%)" = 70.0;
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

    wireplumber = {
      extraScripts = {
        "custom/lock-rnnoise.lua" = ''
          log.info("Loading custom volume lock for rnnoise input")
          local function lock_volume(node)
            if node.properties["node.name"] == "effect_input.rnnoise" then
              log.info("Locking volume for " .. node.properties["node.name"])
              node.properties["volume"] = 1.0
              node.properties["node.fixed-volume"] = true
            end
          end

          -- Process nodes that already exist at startup:
          for i, node in ipairs(core.nodes) do
            lock_volume(node)
          end

          -- Subscribe to new nodes:
          object.subscribe(core, "node-added", function(node)
            lock_volume(node)
          end)
        '';
        "custom/exclude-noise-suppression.lua" = ''
          log.info("Loading custom exclusion for noise suppression")

          local excluded_input = "bluez_input.00:A4:1C:8C:6B:AF"

          local function maybe_exclude_link(link)
            local src = link:property("node.source")
            local sink = link:property("node.sink")
            if src and sink then
              local src_name = src.properties["node.name"] or ""
              local sink_name = sink.properties["node.name"] or ""
              if (sink_name == "effect_input.rnnoise") and (src_name == excluded_input) then
                log.info("Excluding connection from " .. src_name .. " to " .. sink_name)
                link:destroy()  -- Remove the link so that this input never gets processed
              end
            end
          end

          -- Subscribe to link-added events
          object.subscribe(core, "link-added", function(link)
            maybe_exclude_link(link)
          end)
        '';
      };

      extraConfig = {
        "wireplumber.components" = {
          "custom/lock-rnnoise.lua" = builtins.toJSON {
            name = "custom/lock-rnnoise.lua";
            type = "script/lua";
            provides = "custom.lock-rnnoise";
          };
          "custom/exclude-noise-suppression.lua" = builtins.toJSON {
            name = "custom/exclude-noise-suppression.lua";
            type = "script/lua";
            provides = "custom.exclude-noise-suppression";
          };
        };

        "wireplumber.profiles" = {
          main = {
            "custom.lock-rnnoise" = "required";
            "custom.exclude-noise-suppression" = "required";
          };
        };

        "51-disable-pro" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "alsa_card.pci-0000_03_00.1";
                }
              ];
              actions = {
                update-props = {
                  "device.disabled" = true;
                };
              };
            }
          ];
        };
      };
    };
  };

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List services that you want to enable:
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };

  services.ollama = {
    enable = true;
    port = 11434;
    host = "0.0.0.0";
    acceleration = "rocm";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
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

  #udev rules
  #services.udev.extraRules = ''
  # KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
  #'';

}
