{
  config,
  lib,
  pkgs,
  systemName,
  ...
}:
let
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";
in
{
  networking = lib.mkMerge [
    # Hostname per system type
    (lib.mkIf isLaptop { hostName = "mrfluffyLaptop"; })
    (lib.mkIf isPc { hostName = "mrfluffyPC"; })

    # Common networking config
    {
      # Firewall
      firewall = {
        # allowedTCPPorts = [ ... ];
        # allowedUDPPorts = [ ... ];
        enable = false;
        checkReversePath = false;
      };

      # NetworkManager
      networkmanager = {
        enable = true;
        dns = "default";  # Changed from "none" to get DNS from DHCP (router)
      };

      # DHCP
      useDHCP = false;
      dhcpcd.enable = false;

      # IPv6
      enableIPv6 = true;

      # Hosts & DNS
      extraHosts = ''
        127.0.0.0 localhost
      '';
      # nameservers = [ ... ];  # Commented out to use DHCP-provided ones
      search = [
        "localdomain"
        "local"
      ];

      # Proxies (disabled)
      # proxy.default = "http://user:password@proxy:port/";
      # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Wireless (alternative approach, disabled)
      # wireless.enable = true; # wpa_supplicant
    }
  ];
}
