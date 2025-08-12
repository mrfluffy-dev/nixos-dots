{
  config,
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  ...
}:
let
  inherit (pkgs) anime4k;

  # Use writeText instead of writeLua luacheck can't cry about the long lines
  autoAnime4k = pkgs.writeText "auto-anime4k-switcher.lua" ''
    local function get_nearest(x, numbers)
      local min_index = nil
      local min_dist = math.huge

      for i, n in ipairs(numbers) do
        local d = math.abs(n - x)
        if d < min_dist then
          min_index = i
          min_dist = d
        end
      end

      return numbers[min_index]
    end

    -- Fast
    -- local shader_map = {
    --     [1080] = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl",
    --     [720]  = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl",
    --     [480]  = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
    -- }
    -- HQ
    local shader_map = {
      [1080] = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_VL.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl",
      [720]  = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl",
      [480]  = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
    }

    local resolutions = { 1080, 720, 480 }

    mp.register_event("file-loaded", function()
      local height = mp.get_property_number("video-params/h")

      local shaders = shader_map[height]
      if not shaders then
        height = get_nearest(height, resolutions)
        shaders = shader_map[height]
      end

      mp.osd_message("Using " .. height .. "p Anime4K shaders")
      mp.commandv("change-list", "glsl-shaders", "set", shaders)
    end)
  '';
in

{
  programs.gamescope = {
    enable = true;

  };
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (self: super: {

      mpv = super.wrapMpv (super.mpv.unwrapped.override { sixelSupport = true; }) {
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
  #
  #

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "$HOME/nixos-dots/"; # sets NH_OS_FLAKE variable for you
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
  programs.virt-manager.enable = true;
  programs.zsh.enable = true;
  programs.corectrl.enable = true;
  programs.opengamepadui = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession = {
      enable = true;
    };
  };
  # enable dynamic bin executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add libraries here
    #alsa-lib
    #libGL
    #glibc
    #glib
    #fontconfig
    #xorg.libX11
    #xorg.libXcomposite
    #xorg.libXdamage
    #xorg.libXfixes
    #xorg.libXrender
    #xorg.libXrandr
    #xorg.libXtst
    #xorg_sys_opengl
    #xorg.libXi
    #xorg.libxshmfence
    #xorg.libxkbfile
    #xorg.libxcb
    #xorg.xcbutilwm
    #xorg.xcbutilimage
    #xorg.xcbutilkeysyms
    #xorg.xcbutilrenderutil
    #xcb-util-cursor
    #libgbm
    #libxkbcommon
    #freetype
    #dbus
    #krb5
    #nss
    #zotero
    #nspr
    #gtk3
    #libappindicator-gtk3
    #mesa
    #vulkan-loader
  ];

  #backlight tool
  programs.light.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wl-clipboard
    bat
    anime4k
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
    ffmpeg
    libva-utils
    nixfmt-rfc-style
    nil
    kdePackages.qt6ct
    ripgrep
    xwayland-satellite
    cmake
    gnumake
    gcc
    libtool
    ladspaPlugins
    inputs.nix-alien.packages.${pkgs.system}.nix-alien
    python311
  ];
}
