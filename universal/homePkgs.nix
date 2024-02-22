{ config, lib, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;
   home.packages = with pkgs; [

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
     zsh
     firefox
     btop
     libreoffice-fresh
     eww-wayland
     cargo
     rustc
     rust-analyzer
     macchina
     hyprpaper
     obs-studio
     xwaylandvideobridge
     blueman
     duf
     grim
     slurp
     swappy
     heroic
     gamemode
     gamescope
     goverlay
     rm-improved
     nodejs_20
     playerctl
     pamixer
     minecraft
     openai-whisper
     libreoffice
     blender-hip
     zathura
     imv
     libsixel
     prismlauncher-qt5
     godot_4
     wf-recorder
     jellyfin-media-player
     pcmanfm
     hyprpicker
     mangohud
     gamemode
     vesktop
     mpv
     rofi
  ];
}
