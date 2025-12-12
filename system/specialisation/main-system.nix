{
  config,
  lib,
  pkgs,
  window_manager,
  systemName,
  inputs,
  ...
}:

let
  oreo = pkgs.callPackage ./personalPKGS/oreo.nix { };

  # Window manager toggles
  wmAll = window_manager == "all";
  useRiver = window_manager == "river" || wmAll;
  useNiri = window_manager == "niri" || wmAll;
  useHypr = window_manager == "hyprland" || wmAll;
in

{
  # greetd + tuigreet
  services.greetd = {
    enable = true;
    restart = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --window-padding 1 --time --time-format '%R - %F' --remember --remember-session --asterisks";
      user = "greeter";
    };
  };

  ##############################################################################
  # Desktop / WM
  ##############################################################################
  programs.river-classic.enable = useRiver;

  qt = {
    enable = true;
    # style = "gtk2";
    platformTheme = "qt5ct";
  };

  xdg.menus.enable = true;

  # Work around Dolphin menu oddities: force Plasma menu definition
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Niri (via overlay)
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  #programs.niri = {
  #  enable = useNiri;
  #  package = pkgs.niri-stable; # Only needed if not provided by the overlay
  #};

  # Hyprland
  programs.hyprland = {
    enable = useHypr;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # X11 base (kept enabled for keymap + DM if needed)
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ie";
      variant = "";
    };

    # displayManager.lightdm = {
    #   enable = true;
    #   greeters.gtk = {
    #     enable = true;
    #     theme.package = pkgs.amarena-theme;
    #     theme.name = "amarena";
    #     cursorTheme.package = oreo.override { colors = [ "oreo_spark_pink_cursors" ]; };
    #     cursorTheme.name = "oreo_spark_pink_cursors";
    #     extraConfig = "background=${./assets/Wallpapers/138.png}";
    #   };
    # };
  };

  ##############################################################################
  # Security / PolicyKit / PAM
  ##############################################################################
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      swaylock = { };
      greetd.enableGnomeKeyring = true;
      greetd.kwallet.enable = true;
    };
  };

  ##############################################################################
  # Virtualisation
  ##############################################################################
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = lib.mkIf (systemName == "pc") "btrfs";
    };
    libvirtd.enable = true;
  };

}
