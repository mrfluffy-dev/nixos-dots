{
  config,
  pkgs,
  inputs,
  lib,
  window_manager,
  ...
}:
let
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    inputs.nixcord.homeModules.nixcord
    #inputs.niri.homeModules.niri
    ./sessionVars.nix
    ../dots/foot.nix
    ../dots/waybar.nix
    ../dots/zsh.nix
    ../dots/nixcord.nix
    ../dots/hyprlock.nix
    ./stylix.nix
    ./homePkgs.nix
    ./services.nix
    ../dots/xdg.nix
    ../dots/river.nix
    ../dots/niri.nix
    ../dots/hyprland.nix
    ../dots/hyprpaper.nix

  ];

  # you can go look here for a list of color schemes https://github.com/tinted-theming/schemes
  colorScheme = inputs.nix-colors.colorSchemes.hardcore;
  stylix.base16Scheme.base00 = "141414";
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mrfluffy";
  home.homeDirectory = "/home/mrfluffy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #gtk = {
  #  enable = true;
  #  iconTheme = {
  #    name = "Dracula";
  #    #  package = pkgs.dracula-icon-theme;
  #  };
  #};

  home.packages = with pkgs; [
    swaybg
    lswt
    wlr-randr
    #inputs.ladybird.packages."${pkgs.system}".ladybird

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
    #".config/doom".source = ../dots/doom;
    ".config/quickshell".source = ../dots/quickshell;
    #".config/kitty".source = ../../universal/dots/kitty;
    #".config/nvim".source = ../../universal/dots/nvim;
    "Pictures/Wallpapers".source = ../assets/Wallpapers;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mrfluffy/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
