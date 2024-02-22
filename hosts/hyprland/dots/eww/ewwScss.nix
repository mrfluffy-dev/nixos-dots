{ pkgs, config, ... }:

{
  home.file = {
    ".config/eww/eww.scss".text = ''


.bar{
}
.workspaces{
    padding-right: 300px;
}

.W0 , .W01, .W02, .W03, .W04, .W05, .W06, .W07, .W08, .W09,.W011, .W022, .W033, .W044, .W055, .W066, .W077, .W088, .W099,{
  margin: 0px 0px 0px 0px;
}

// Unoccupied
.W0 {
	color: #${config.colorScheme.colors.base01};
}

// Occupied
.W01, .W02, .W03, .W04, .W05, .W06, .W07, .W08, .W09 {
	color:#${config.colorScheme.colors.base08};
    font-weight: bold;
}


// Focused
.W011, .W022, .W033, .W044, .W055, .W066, .W077, .W088, .W099{
	color: #${config.colorScheme.colors.base0A};
	font-weight:bold;
}


.bar_right{
    //padding left
    padding-left: 130px;
}
.disk{
    //font size
    font-size: 12px;
    //ring color lime green
    color: #${config.colorScheme.colors.base0A};
}
.cpu{
    //font size
    font-size: 12px;
    //color dracula purple
    color: #${config.colorScheme.colors.base09};
}
.mem{
    //font size
    font-size: 12px;
    //color dracula yellow
    color: #${config.colorScheme.colors.base0B};
}

.net{
    //color dracula blue
    color: #${config.colorScheme.colors.base0D};
}

.time{
    //color dracula orange
    color: #${config.colorScheme.colors.base0C};
    background-color: inherit;
}

.idle{

}

.idle_btn_on{
    //color dracula pink
    color: #${config.colorScheme.colors.base08};
    background-color: inherit;
}

.idle_btn_off{
    //color dracula red
    color: #${config.colorScheme.colors.base03};
    background-color: inherit;
}

  '';
  };
}
