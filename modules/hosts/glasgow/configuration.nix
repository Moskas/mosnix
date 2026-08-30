{ self, inputs, ... }:
{
  flake.nixosConfigurations.glasgow = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.glasgow ];
  };
  flake.nixosModules.glasgow = {

    imports = [
      self.nixosModules.common
      self.nixosModules.commonWorkstation
      self.nixosModules.laptop
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasProfile
    ];

    moskas.profile = "full";
    home-manager.users.moskas.moskas.desktop.bar.position = "bottom";

    networking = {
      hostName = "glasgow";
    };

    services.udev.extraHwdb = ''
      touchpad:i8042:*
        LIBINPUT_MODEL_LENOVO_X220_TOUCHPAD_FW81=1
    '';

    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };

    # wifi chip: intel 6205
    boot.extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlwifi uapsd_disable=1
    '';

    services.tlp.settings = {
      CPU_SCALING_MAX_FREQ_ON_AC = 2400000;
    };

  };
}
