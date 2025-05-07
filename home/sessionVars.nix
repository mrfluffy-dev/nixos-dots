{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    EDITOR = "emacs";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    QT_QPA_PLATFORM = "wayland";
    #XDG_CURRENT_DESKTOP = "hyprland";
    #XDG_SESSION_DESKTOP = "hyprland";
    MOZ_ENABLE_WAYLAND = 1;
    WLR_DRM_NO_ATOMIC = 1;
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    OLLAMA_HOST = "0.0.0.0";
    PATH = "$HOME/.config/emacs/bin:$PATH";
    FZF_DEFAULT_COMMAND = "${lib.getExe pkgs.ripgrep} ~ --files --hidden";
    FZF_DEFAULT_OPTS = "--height 30% --reverse";
    FZF_CTRL_R_OPTS = "--sort";
    MANROFFOPT = "-c";
    MANPAGER = "sh -c 'col -bx | ${lib.getExe pkgs.bat} -l man -p'";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
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
    ZDOTDIR = "$HOME/.config/zsh";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#64677a,bold,underline";
  };

}
