{ self, inputs, ... }:
{
  flake.nixosConfigurations.glasgow = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.glasgow ];
  };
  flake.nixosModules.glasgow = {

    imports = [
      self.nixosModules.commonWorkstation
      self.nixosModules.laptop
      self.nixosModules.vm-test
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.graphical
      self.nixosModules.moonlight
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x220
      inputs.nixos-hardware.nixosModules.common-gpu-intel
    ];

    moskas = {
      desktop.bar = {
        position = "bottom";
        layout = {
          start = [
            "control-center"
            "workspaces"
          ];
          center = [ ];
          end = [
            "media"
            "tray"
            "network"
            "volume"
            "brightness"
            "battery"
            "clock"
            "group:notify"
          ];
        };
      };
      fonts.sizes = {
        desktop = 12;
        terminal = 12;
        popups = 12;
        applications = 12;
      };
    };

    home-manager.users.moskas = {
      imports = [ self.homeModules.prism ];
      programs.mpv.config.profile = "fast";
    };

    networking = {
      hostName = "glasgow";
    };

    services.udev.extraHwdb = ''
      touchpad:i8042:*
        LIBINPUT_MODEL_LENOVO_X220_TOUCHPAD_FW81=1
    '';

    # fingerprint reader: upek 147e:2016 (libfprint upekts driver)
    services.fprintd.enable = true;

    security.pam = {
      services = {
        sudo.fprintAuth = true;
        ly.fprintAuth = true;
      };
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
