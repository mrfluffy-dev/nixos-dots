{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:
{
  networking = {
    # Define hostname based on system type
    hostName = lib.mkMerge [
      (lib.mkIf (systemName == "laptop") "mrfluffyLaptop")
      (lib.mkIf (systemName == "pc") "mrfluffyPC")
    ];

    # Firewall configuration
    firewall = {
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      enable = false;
      checkReversePath = false;
    };

    # Networking options
    # Pick only one of the below networking options.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
      dns = "none";
    };

    # DHCP settings
    useDHCP = false;
    dhcpcd.enable = false;

    # IPv6 configuration
    enableIPv6 = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Hosts and DNS configuration
    extraHosts = ''
      127.0.0.0 localhost
    '';
    nameservers = [
      "192.168.1.1"
      ""
      ];
    search = [ "localdomain" ];

    # # environment.etc = {
    # # "resolv.conf".text = "nameserver 192.168.1.180\noptions edns0 trust-ad\nsearch home\n";
    # # };
  };
}
