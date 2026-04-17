{
  flake.nixosModules.dns = {
    config = {
      services.dnsmasq = {
        enable = true;
        resolveLocalQueries = true;
        settings = {
          domain-needed = true;
          bind-interfaces = true;
          address = [
            "/nagato.taila32e5.ts.net/100.104.30.29"
            "/*.nagato.taila32e5.ts.net/100.104.30.29"
            "/*.nagato.local/100.104.30.29"
            "/laffey.taila32e5.ts.net/100.74.143.11"
            "/*.laffey.taila32e5.ts.net/100.74.143.11"
          ];
          server = [
            "100.100.100.100"
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
      networking.firewall.interfaces."enp1s0".allowedTCPPorts = [
        80
        443
        53
      ];
    };
  };
}
