{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.hostName = "mrfluffyPC"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  #networking.enableIPv6 = false;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.extraHosts = ''
    127.0.0.0 localhost
  '';
  networking.nameservers = [ "192.168.1.180" ];
  #  # environment.etc = {
  #  #   "resolv.conf".text = "nameserver 192.168.1.180\noptions edns0 trust-ad\nsearch home\n";
  #  # };
}
