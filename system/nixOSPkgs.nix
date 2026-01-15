{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-stable,
  ...
}:
let
  inherit (pkgs) anime4k;

  # Use writeText instead of writeLua so linters don't complain about long lines
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

    -- HQ shader map
    local shader_map = {
      [1080] = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_VL.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl",
      [720] = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl",
      [480] = "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
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
  ############################
  # Nixpkgs & overlays
  ############################
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        mpv = super.wrapMpv (super.mpv.unwrapped.override { sixelSupport = true; }) {
          scripts = [ self.mpvScripts.mpris ];
        };
      })
    ];
  };



  ############################
  # Core programs
  ############################
  programs = {
    dconf.enable = true;

    appimage = {
      enable = true;
      binfmt = true;  # Optional: Allows direct execution of .AppImage files without `appimage-run` prefix
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: with pkgs; [
          libepoxy
	  jdk17
          # Add more if needed, e.g., libGL libGLU for OpenGL issues
        ];
      };
    };
    gamescope = {
      enable = true;
      capSysNice = false;
    };

    nix-index-database = {
      comma = {
        enable = true;
      };
    };


    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
      flake = "$HOME/nixos-dots/"; # sets NH_OS_FLAKE
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    virt-manager.enable = true;
    corectrl.enable = true;

    opengamepadui = {
      enable = true;
      gamescopeSession.enable = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [ gamescope mangohud gamemode ];
      gamescopeSession.enable = false;
    };

    # Dynamic linker for foreign binaries
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        gcc15.cc.lib
        # add libraries here if needed
        # alsa-lib
        # libGL
        # glibc
        # ...
      ];
    };

    # Backlight tool
    light.enable = true;

    # NetworkManager applet
    nm-applet = {
      enable = false;
      indicator = false;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    xfconf.enable = true;

  };

  ############################
  # System packages
  ############################
  environment.systemPackages = with pkgs; [
    # --- Editors & Shell UX ---
    bat
    neovim
    vim
    zoxide

    # --- CLI essentials ---
    eza
    fd
    fzf
    ripgrep
    wget
    xcp
    zip
    unzip

    # --- Nix tooling ---
    nil
    nixfmt
    inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien

    # --- Wayland / Desktop ---
    foot
    libdecor
    wl-clipboard
    xwayland-satellite

    # --- Media / Graphics ---
    anime4k
    ffmpeg
    libva-utils
    pavucontrol

    # --- Networking / Secrets ---
    bitwarden-desktop
    polkit_gnome
    xclip
    socat

    # --- Development toolchains ---
    cmake
    gcc15
    gnumake
    jdk11
    ladspaPlugins
    libtool
    python311

    # --- Spellcheck / Fonts ---
    hunspell
    hunspellDicts.en_US

    # --- KDE Wallet bits ---
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.kwallet-pam

    # --- Apps ---
    git
    zotero


    # --- File System Stuff ---
    cifs-utils

  ];
}
