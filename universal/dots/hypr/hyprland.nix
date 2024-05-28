{ pkgs, config, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf".text = ''

# vars go here trust me bro

exec-once=waybar
exec-once=systemctl --user restart xdg-desktop-portal
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
#exec-once=~/.config/script/waylock.sh
exec-once=(hypridle &) && loginctl unlock-session
exec-once=hyprpaper
exec-once=foot -s
exec-once=ollama serve
# exec-once=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1  # Arch way
exec-once=/nix/store/$(ls -la /nix/store | grep 'polkit-gnome' | grep '^d' | awk '$0=$NF' | head -n 1)/libexec/polkit-gnome-authentication-agent-1
exec-once=autoadb scrcpy -s '{}'
exec-once=hyprctl setcursor oreo_spark_pink_cursors 16
exec-once=fcitx5 -d

monitor=HDMI-A-2,1920x1080@60,0x0,1
monitor=DP-1,2560x1440@144,1920x0,1

workspace=HDMI-A-2,10
#workspace=HDMI-A-1,1
workspace=DP-1,1
workspace=DP-1,2
workspace=DP-1,3
workspace=DP-1,4
workspace=DP-1,5
workspace=DP-1,6
workspace=DP-1,7
workspace=DP-1,8
workspace=DP-1,9

misc:disable_hyprland_logo=true
misc:enable_swallow=true
misc:no_direct_scanout=false
misc:vfr=false

input {
    numlock_by_default=true
    follow_mouse=1
    repeat_delay=300
    repeat_rate=50

    touchpad {
        natural_scroll=no
    }
}

general {
    sensitivity=1.0 # for mouse cursor
    gaps_in=5
    gaps_out=5
    border_size=2
    layout=master
    apply_sens_to_raw=1 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
    allow_tearing = true
    col.active_border=rgba(${config.colorScheme.colors.base08}ff)
    col.inactive_border=rgba(${config.colorScheme.colors.base0D}ff)
}

group {
    col.border_active=0xff8218c4
    col.border_inactive=0xff282a36
}

decoration {
    #blur_ignore_opacity     =   true
    #blur_new_optimizations = true
    rounding=10
    #blur=1
    #blur_size=5 # minimum 1
    #blur_passes=1 # minimum 1, more passes = more resource intensive.
    # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
    # if you want heavy blur, you need to up the blur_passes.
    # the more passes, the more you can up the blur_size without noticing artifacts.
}

animations {
    enabled=1
    animation=windows,1,7,default,popin 80%
    animation=border,1,7,default
    animation=fade,1,7,default
    animation=workspaces,1,6,default
}

master {
    new_on_top=true
}

dwindle {
    pseudotile=0 # enable pseudotiling on dwindle
    force_split=2
}

gestures {
    workspace_swipe=no
}

windowrule=fullscreen,mpv
windowrule=float,qalculate-gtk
windowrule=float,imv
windowrule=float,scrcpy
windowrule=float,title:^(whisper)$
windowrule=size 412 876, scrcpy
windowrule=center, scrcpy
                   #tearing rules
windowrulev2 = immediate, title:^(DOOMEternal)$

# rofi
windowrule = float, Rofi
blurls=rofi

windowrule=float,title:^(kami)$
windowrule=float,title:^(Open files)$
windowrule=size 1011 781,title:^(kami)$
#windowrule=center,title^(kami)$
windowrule=move 724 358,title:^(kami)$

windowrule=stayfocused,title:^(rofi - drun)$
windowrule=forceinput,title:^(rofi - drun)$
windowrule = move cursor -50% -50%,^title:^(rofi - drun)$

#windowrule=pseudo,abc
#windowrule=monitor 0,xyz
windowrule=tile,WebApp-ytmusic4224
windowrule=tile,WebApp-discord5149

windowrulev2 = stayfocused, title:^()$,class:^(steam)$
windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$

windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
windowrulev2 = noanim,class:^(xwaylandvideobridge)$
windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$
windowrulev2 = maxsize 1 1,class:^(xwaylandvideobridge)$
windowrulev2 = noblur,class:^(xwaylandvideobridge)$
#windowrule=workspace 10,krita
#windowrule=workspace 10,inkscape
#windowrule=workspace 10,Gimp-2.10
#windowrule=workspace 10,Blender

bind=ALT,Return,exec,footclient
bind=ALT,A,exec,~/repos/Mangayomi-v0.0.7-linux.AppImage
bind=ALT,Q,killactive,
bind=ALT,F,exec,pcmanfm
bind=ALT,B,exec,firefox
bind=ALT,E,exec,emacsclient -r
bind=,107,exec,~/.config/script/wayscreenshot.sh
bind=ALT,P,exec,hyprpicker -f hex | wl-copy
bind=ALT,Z,exec,~/.config/hypr/monitors.sh
bind=SHIFT,107,exec,grim -g "$(slurp)" - | wl-copy
bind=ALTSHIFT,Q,exit,
bind=ALTSHIFT,F,togglefloating,
bind=ALTSHIFT,T,fullscreen,0
bind=ALT,D,exec,anyrun
bind=ALT,S,exec,foot -T whisper ~/.config/script/wisper.sh

# toggle waybar
bind=SUPER,W,exec,~/.config/script/hide_waybar.sh

bind=ALT,H,focusmonitor,DP-2
bind=ALT,L,focusmonitor,DP-3
bind=ALT,K,cyclenext,prev
bind=ALT,J,cyclenext,

bind=ALTSHIFT,H,movewindow,l
bind=ALTSHIFT,L,movewindow,r
bind=ALTSHIFT,K,movewindow,u
bind=ALTSHIFT,J,movewindow,d

#floating toggle
bind=ALT,T,togglefloating,

# move window with mouse
bindm=ALT,mouse:272,movewindow
bindm=ALT,mouse:273,resizewindow

# resize Mode with Alt + R : Press Escape to quit
bind=ALT,R,submap,resize # will switch to a submap called resize
submap=resize # will start a submap called "resize"

bind=,l,resizeactive,30 0
bind=,h,resizeactive,-30 0
bind=,k,resizeactive,0 -30
bind=,j,resizeactive,0 30

bind=,escape,submap,reset # use reset to go back to the global submap
submap=reset # will reset the submap, meaning end the current one and return to the global one.

# audio controlls
bind=,XF86AudioRaiseVolume,exec,pamixer -i 5
bind=,XF86AudioLowerVolume,exec,pamixer -d 5
bind=,XF86AudioMute,exec,pamixer --toggle-mute

# media controlles
bind=,XF86AudioMedia,exec,playerctl play-pause
bind=,XF86AudioPlay,exec,playerctl play-pause
bind=,XF86AudioPrev,exec,playerctl previous
bind=,XF86AudioNext,exec,playerctl next

bind=ALT,1,workspace,1
bind=ALT,2,workspace,2
bind=ALT,3,workspace,3
bind=ALT,4,workspace,4
bind=ALT,5,workspace,5
bind=ALT,6,workspace,6
bind=ALT,7,workspace,7
bind=ALT,8,workspace,8
bind=ALT,9,workspace,9
bind=ALT,0,workspace,10
bind=ALT,51,togglespecialworkspace

bind=ALTSHIFT,1,movetoworkspacesilent,1
bind=ALTSHIFT,2,movetoworkspacesilent,2
bind=ALTSHIFT,3,movetoworkspacesilent,3
bind=ALTSHIFT,4,movetoworkspacesilent,4
bind=ALTSHIFT,5,movetoworkspacesilent,5
bind=ALTSHIFT,6,movetoworkspacesilent,6
bind=ALTSHIFT,7,movetoworkspacesilent,7
bind=ALTSHIFT,8,movetoworkspacesilent,8
bind=ALTSHIFT,9,movetoworkspacesilent,9
bind=ALTSHIFT,0,movetoworkspacesilent,10
bind=ALT,48,movetoworkspace,special

bind=SUPER,mouse_down,workspace,e+1
bind=SUPER,mouse_up,workspace,e-1

bind=ALT,49,togglegroup
bind=ALT,tab,changegroupactive

  '';
  };
}
