{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    kernelModules = lib.mkForce [
      "cec"
    ];
    kernelParams = lib.mkForce [
      "ipv6e=1"
      "quiet"
      "splash"
    ];
    plymouth = {
      enable = true;
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
      theme = "abstract_ring_alt";
    };
  };

  # ── HDMI-CEC: Turn on TV when Steam specialisation starts ─────────────────────
  services.udev.packages = [ pkgs.libcec ]; # ensures cec-utils is in PATH
  services.blueman.enable = true;
  services.seatd.enable = true;

  # A user service that runs once the graphical session (Steam/GameScope) is ready
  systemd.services.cec-tv-control = {
    description = "Control TV via HDMI-CEC (turn on early, turn off on shutdown)";
    wantedBy = [ "multi-user.target" ];

    # Run very early: after modules load and local filesystems are available,
    # but before Plymouth boot splash quits and before the display manager
    after = [
      "systemd-modules-load.service"
      "local-fs.target"
      "systemd-udev-settle.service"
    ];
    before = [
      "plymouth-quit-wait.service"
      "greetd.service"
    ];

    # Ensure the /dev/cec* device exists (udev settles early)
    requires = [ "systemd-udev-settle.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      # Turn TV on during boot
      ExecStart = toString (
        pkgs.writeShellScript "cec-tv-on.sh" ''
          sleep 3  # Give CEC time to initialize
          ${pkgs.libcec}/bin/cec-client -s -d 1 <<EOF
          on 0
          EOF
          sleep 2
          ${pkgs.libcec}/bin/cec-client -s -d 1 <<EOF
          as
          EOF
        ''
      );

      # Turn TV off on shutdown/reboot (ExecStop runs when the service stops)
      ExecStop = toString (
        pkgs.writeShellScript "cec-tv-off.sh" ''
          ${pkgs.libcec}/bin/cec-client -s -d 1 <<EOF
          standby 0
          EOF
        ''
      );
    };
  };
  # THIS is the important part – direct boot into the Gamescope Steam session
  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      # Tell greetd to auto-start the official gamescope steam session immediately
      # HDMI-A-2
      default_session = {
        command = "${pkgs.gamescope}/bin/gamescope --prefer-output HDMI-A-2  --hdr-enabled --steam --mangoapp  -- steam -pipewire-dmabuf -gamepadui -steamos3 > /dev/null 2>&1";
        user = "game";
      };
    };
  };

  # Auto-login the game user (no password prompt ever)
  services.getty.autologinUser = "game";
  # Make sure the user service starts automatically
  systemd.user.targets.graphical-session = {
    # This target already exists, we just ensure it’s active
    unitConfig = {
      RefuseManualStart = false;
      RefuseManualStop = false;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      mangohud
      gamemode
      gamescope-wsi
    ];
    variables = {
      #LIBSEAT_BACKEND = "logind";
    };

  };
  jovian.decky-loader = {
    enable = true;
    user = "game"; # Run as your gaming user
    stateDir = "/home/game/.local/share/decky"; # Store plugins/data in user's home (adjust if preferred)
    # Optional: Add extra packages if needed for specific plugins
    # extraPackages = with pkgs; [ some-package ];
    # extraPythonPackages = ps: with ps; [ some-python-package ];
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        gamescope
        mangohud
        gamemode
        gamescope-wsi
      ];
      gamescopeSession = {
        enable = true;
      };
    };
  };
}
