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
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";

  oreo = pkgs.callPackage ./personalPKGS/oreo.nix { };

  # Window manager toggles
  wmAll = window_manager == "all";
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
  #services.displayManager.dms-greeter = {
  #  enable = true;
  #  compositor.name = "hyprland"; # Or "hyprland" or "sway"
  #  configHome = "${config.users.users.mrfluffy.home}";
  #};
  #services.displayManager.cosmic-greeter.enable = true;

  # ─── Desktop / WM ───────────────────────────────────────────────────────────
  qt = {
    enable = true;
  };

  xdg.menus.enable = true;

  # Work around Dolphin menu oddities: force Plasma menu definition
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Niri
  programs.niri.enable = useNiri;

  # Hyprland
  programs.hyprland = {
    enable = useHypr;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  #services.desktopManager.cosmic = {
  #  enable = true;
  #};

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

  # ─── Security / PolicyKit / PAM ─────────────────────────────────────────────
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      swaylock = { };
      greetd.enableGnomeKeyring = true;
      greetd.kwallet.enable = true;
    };
  };

  # ─── Virtualisation ─────────────────────────────────────────────────────────
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = lib.mkIf isPc "btrfs";
    };
    libvirtd.enable = true;
  };

}
