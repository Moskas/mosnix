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
      self.nixosModules.nvidia
      self.nixosModules.gaming
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasProfile
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

    moskas = {
      profile = "full";
      # Resolved on the NixOS side into the home feature set.
      home.obs.enable = true;
    };

    services.sunshine = {
      enable = true;
    };

    home-manager.users.moskas = {
      moskas.obs.cuda = true;
      wayland.windowManager.niri.settings._children = [
        {
          output = {
            _args = [ "Acer Technologies XB253Q TH5EE0058521" ];
            mode = "1920x1080@143.981";
          };
        }
      ];
    };
  };
}
