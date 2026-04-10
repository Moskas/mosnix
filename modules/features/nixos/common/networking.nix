{
  flake.nixosModules.common = {
    config = {
      networking = {
        networkmanager = {
          enable = true;
          wifi = {
            macAddress = "random";
          };
        };
        firewall = {
          allowedTCPPorts = [
            22
          ];
          allowedUDPPorts = [
          ];
        };
      };
    };
  };
}
