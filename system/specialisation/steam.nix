{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
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
  #systemd.user.services.cec-tv-on = {
  #  description = "Turn on TV via HDMI-CEC when entering Steam specialisation";
  #  wantedBy = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #    ExecStart = toString (
  #      pkgs.writeShellScript "cec-tv-on.sh" ''
  #        # Wait a moment for the HDMI link to settle
  #        sleep 3

  #        # Turn on the TV and set it as active source (most TVs understand this)
  #        ${pkgs.libcec}/bin/cec-client -s -d 1 <<EOF
  #        on 0
  #        as
  #        EOF

  #        # Alternative one-liner if the above somehow fails:
  #        # echo 'on 0' | ${pkgs.libcec}/bin/cec-client -s -d 1
  #        # echo 'as'  | ${pkgs.libcec}/bin/cec-client -s -d 1
  #      ''
  #    );
  #  };
  #};

  # THIS is the important part – direct boot into the Gamescope Steam session
  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      # Tell greetd to auto-start the official gamescope steam session immediately
      default_session = {
        command = "${pkgs.gamescope}/bin/gamescope --prefer-output HDMI-A-2 --hdr-enabled --steam --mangoapp  -- steam -pipewire-dmabuf -gamepadui -steamos3 > /dev/null 2>&1";
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
