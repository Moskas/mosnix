{ self, inputs, ... }:
{
  flake.nixosConfigurations.glasgow = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.glasgow ];
  };
  flake.nixosModules.glasgow = { pkgs, ... }: {

    imports = [
      self.nixosModules.commonWorkstation
      self.nixosModules.ddcutil
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

    # tp_smapi installs its .ko files manually, so they lack the kmodigest .ko.cer
    # certificates the kernel module aggregator now expects
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest.extend (
      _: prev: {
        tp_smapi = prev.tp_smapi.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.buildPackages.kmodigest ];
          postInstall = (old.postInstall or "") + ''
            for module in "$out"/lib/modules/*/kernel/drivers/firmware/*.ko; do
              kmodigest "$module"
            done
          '';
        });
      }
    );

    # wifi chip: intel 6205
    boot.extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlwifi uapsd_disable=1
    '';

    services.tlp.settings = {
      CPU_SCALING_MAX_FREQ_ON_AC = 2400000;
    };

    # analog and DP audio share one ALSA card and the default profiles only offer one output at
    # a time, so expose both as sinks; mappings are copied from the default profile set
    # the profile must be probed: skip-probe leaves it without mixer paths, so mute and volume
    # never reach the ALSA Master control that drives the keyboard mute LEDs
    services.pipewire.wireplumber.extraConfig."99-analog-hdmi-profile" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "device.name" = "alsa_card.pci-0000_00_1b.0"; } ];
          actions.update-props."device.profile-set" = "${pkgs.writeText "analog-hdmi.conf" ''
            [General]
            auto-profiles = no

            [Mapping analog-stereo]
            device-strings = front:%f
            channel-map = left,right
            paths-output = analog-output analog-output-lineout analog-output-speaker analog-output-headphones analog-output-headphones-2
            paths-input = analog-input-front-mic analog-input-rear-mic analog-input-internal-mic analog-input-dock-mic analog-input analog-input-mic analog-input-linein analog-input-aux analog-input-video analog-input-tvtuner analog-input-fm analog-input-mic-line analog-input-headphone-mic analog-input-headset-mic
            priority = 15

            [Mapping hdmi-stereo]
            description = Digital Stereo (HDMI)
            device-strings = hdmi:%f
            paths-output = hdmi-output-0
            channel-map = left,right
            priority = 9
            direction = output

            [Profile output:analog-stereo+output:hdmi-stereo+input:analog-stereo]
            description = Analog Stereo Duplex + Digital Stereo (HDMI) Output
            output-mappings = analog-stereo hdmi-stereo
            input-mappings = analog-stereo
            priority = 100
          ''}";
        }
      ];
    };

  };
}
