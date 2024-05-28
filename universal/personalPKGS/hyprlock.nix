{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libGL
, libxkbcommon
, hyprlang
, pam
, wayland
, wayland-protocols
, cairo
, pango
, libdrm
, mesa
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hyprlock";
  version = "0-unstable-2024-02-22";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "f411d9d632182fe7b23a2796698e6f857badf0af";
    hash = "sha256-dUyFOfMFfH1KproGJcGjOASLF6t2UkkcmTbj49lpauM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    hyprlang
    libdrm
    libGL
    libxkbcommon
    mesa
    pam
    pango
    wayland
    wayland-protocols
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Hyprland's GPU-accelerated screen locking utility";
    homepage = "https://github.com/hyprwm/hyprlock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "hyprlock";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
