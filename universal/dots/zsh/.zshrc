# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#64677a,bold,underline"
bindkey -v
source ~/.zsh/spaceship/spaceship.zsh
export PATH=$HOME/.config/emacs/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
export FZF_DEFAULT_OPTS='--height 30% --reverse'
export FZF_CTRL_R_OPTS='--sort'
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export LD_LIBRARY_PATH=/usr/local/lib:$HOME/.nix-profile/lib:$LD_LIBRARY_PATH

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U compinit && compinit -u
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[N" down-line-or-beginning-search
alias nix-switch="sudo nixos-rebuild switch"
alias nix-upgrade="sudo nixos-rebuild switch --upgrade"
alias nix-edit="sudo vim /etc/nixos/configuration.nix"
alias ls="exa -lag --icons"
alias upload="~/.config/script/upload.sh"
alias record="~/.config/script/record.sh"
alias speak="~/.config/script/wisper.sh"
alias vim="nvim"
alias cat="bat"
alias anime="~/repos/ani-cli/ani-cli"
alias hentai="~/repos/and-scripts/fap-cli"
alias manga="manga-cli"
alias yt="~/repos/ytfzf/ytfzf  --thumb-viewer='kitty' -t"
alias cd="z"
alias rm="rip"
alias df="duf"
alias time="hyperfine"
alias kami="~/Documents/Rust/kami/target/release/kami"
alias calc="cpc"
alias pdf="mupdf"
alias emacs="emacs"
alias river="dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river && river"
#home clean up
export EDITOR="emacs"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export KERAS_HOME="${XDG_STATE_HOME}/keras"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
export XCOMPOSECACHE="${XDG_CACHE_HOME}"/X11/xcompose
export SSB_HOME="$XDG_DATA_HOME"/zoom
#compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export ZDOTDIR="$HOME"/.config/zsh


#alias mv="mvg -g"
alias cp="xcp"
macchina
#[ -f ~/.zsh/.fzf.zsh ] && source ~/.zsh/.fzf.zsh
export PATH=$PATH:$HOME/.spicetify
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

nixdev() {
  if [[ -z "$1" ]]; then
    echo "Usage: nixdev <language>"
    return 1
  fi
  nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
}


#[ -f "/home/mrfluffy/.ghcup/env" ] && source "/home/mrfluffy/.ghcup/env" # ghcup-env
# send all output to void
#ln -s /home/mrfluffy/.nix-profile/share/applications/* ~/.local/share/applications/ 2> /dev/null

#[ -f "/home/mrfluffy/.ghcup/env" ] && source "/home/mrfluffy/.ghcup/env" # ghcup-env

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
