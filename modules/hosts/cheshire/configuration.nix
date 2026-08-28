{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.cheshire = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.cheshire
      self.nixosModules.common
      self.nixosModules.commonWorkstation
      self.nixosModules.gaming
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasHomeManager
      self.nixosModules.profile-full
      self.nixosModules.vm-test
    ];
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

    services.sunshine = {
      enable = true;
    };

    home-manager.users.moskas = {
      imports = [ self.homeModules.obs ];
      moskas.obs.cuda = true;
    };
  };
}
