{
  config,
  lib,
  pkgs,
  ...
}:

{
  fonts.packages = with pkgs; [
    ubuntu_font_family
    siji
    unifont
    noto-fonts
    source-han-code-jp
    source-han-sans
    nerd-fonts.zed-mono
    nerd-fonts.symbols-only
  ];
}
