{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.cheshire = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.stylix.nixosModules.stylix
      self.nixosModules.cheshire
      self.nixosModules.commonWorkstation
      self.nixosModules.gaming
      self.nixosModules.graphical
      self.nixosModules.nvidia
      self.nixosModules.rgb
      self.nixosModules.stylixConfig
      self.nixosModules.sunshine
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

    # Preserve VRAM across suspend in a disk file; the RAM-backed default OOMs and kills the GPU.
    hardware.nvidia = {
      powerManagement.enable = true;
      moduleParams.nvidia.NVreg_TemporaryFilePath = "/var/tmp";
    };

    moskas.obs.cuda = true;

    home-manager.users.moskas = {
      imports = [
        self.homeModules.obs
        self.homeModules.brave
      ];

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
