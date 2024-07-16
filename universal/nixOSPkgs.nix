{ config, lib, pkgs, pkgs-stable, ... }: {
  nixpkgs.config = { allowUnfree = true; };

  nixpkgs.overlays = [
    (self: super: {

      mpv =
        super.wrapMpv (super.mpv.unwrapped.override { sixelSupport = true; }) {
          scripts = [ self.mpvScripts.mpris ];
        };
    })
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.virt-manager.enable = true;
  programs.zsh.enable = true;
  programs.corectrl.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.droidcam.enable = true;
  # enable dynamic bin executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;
    [
      # add libraries here
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wl-clipboard
    bat
    socat
    eza
    wget
    foot
    spaceship-prompt
    git
    bitwarden
    zip
    xclip
    fd
    fzf
    zotero
    jdk11
    hunspell
    hunspellDicts.en_US
    pavucontrol
    zoxide
    xcp
    polkit_gnome
    unzip
    rocmPackages.rccl
    ffmpeg
    libva-utils
    nixfmt-rfc-style
    nil
    #blender-hip
  ];

}
