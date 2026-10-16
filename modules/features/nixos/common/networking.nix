{
  flake.nixosModules.common = { lib, ... }: {
    config = {
      networking = {
        networkmanager = {
          enable = lib.mkDefault true;
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
