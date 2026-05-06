{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.nixosConfigurations.cheshire = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.cheshire ];
  };

  flake.nixosModules.cheshire = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          edk2-uefi-shell.enable = true;
          windows."11".efiDeviceHandle = "HD1b";
          configurationLimit = 20;
        };
      };
    };

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
    };

    networking = {
      hostName = "cheshire";
    };
  };
}
