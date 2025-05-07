{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    plugins = [
      #pkgs.zsh-autosuggestions
      #pkgs.spaceship-prompt
    ];
    autosuggestion = {
      enable = true;
      highlight = "fg=#64677a,bold,underline";
    };
    history = {
      path = "$XDG_DATA_HOME/zsh/history";
    };
    sessionVariables = {
      HISTSIZE = 3000;
      SAVEHIST = 3000;
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      GOPATH = "$XDG_DATA_HOME/go";
      GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
      IPYTHONDIR = "$XDG_CONFIG_HOMEipython";
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      KERAS_HOME = "$XDG_STATE_HOME/keras";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
      SSB_HOME = "$XDG_DATA_HOME/zoom";
      HISTFILE = "$XDG_STATE_HOME/zsh/history";
    };
    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch";
      nix-upgrade = "sudo nixos-rebuild switch --upgrade";
      nix-edit = "sudo vim /etc/nixos/configuration.nix";
      ls = "exa -lag --icons";
      upload = "~/.config/script/upload.sh";
      record = "~/.config/script/record.sh";
      speak = "~/.config/script/wisper.sh";
      vim = "nvim";
      cat = "bat";
      anime = "~/repos/ani-cli/ani-cli";
      hentai = "~/repos/and-scripts/fap-cli";
      manga = "manga-cli";
      yt = "~/repos/ytfzf/ytfzf  --thumb-viewer='kitty' -t";
      cd = "z";
      rm = "rip";
      df = "duf";
      time = "hyperfine";
      kami = "~/Documents/Rust/kami/target/release/kami";
      calc = "cpc";
      pdf = "mupdf";
      emacs = "emacs";
      river = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river && river";
      cp = "xcp";
      wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
    };
    initContent = ''
      eval "$(${lib.getExe pkgs.zoxide} init zsh)"
      eval "$(${lib.getExe pkgs.atuin} init zsh)"
      source ${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh
    '';
    envExtra = ''
      ${lib.getExe pkgs.macchina}
      nixdev() {
        if [[ -z "$1" ]]; then
          echo "Usage: nixdev <language>"
          return 1
        fi
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
      }
    '';
  };
}

