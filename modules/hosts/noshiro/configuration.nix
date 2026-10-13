{ self, inputs, ... }:

{
  flake.nixosConfigurations.noshiro = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.noshiro
    ];
  };
  flake.nixosModules.noshiro = { pkgs, lib, ... }: {
    imports = [
      inputs.stylix.nixosModules.stylix
      inputs.t480.nixosModules.default
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      self.nixosModules.common
      self.nixosModules.commonWorkstation
      self.nixosModules.gaming
      self.nixosModules.laptop
      self.nixosModules.graphical
      self.nixosModules.secureboot
      self.nixosModules.stylixConfig
      self.nixosModules.vm-test
    ];

    moskas = {
      colorscheme = "solarized-dark";
    };

    services.fingerprint06cb009a = {
      enable = true;
      backend = "python-validity";
    };

    security.pam = {
      services = {
        sudo.fprintAuth = true;
        ly.fprintAuth = true;
      };
    };

    # open-fprintd ships a suspend hook (open-fprintd-suspend.service) that tells
    # the driver to cleanly release the sensor before sleep, but nixpkgs'
    # systemd.packages doesn't process a unit's own [Install] section, so it's
    # never pulled in unless we do it ourselves.
    systemd.targets =
      lib.genAttrs [ "suspend" "hibernate" "hybrid-sleep" "suspend-then-hibernate" ]
        (_: {
          wants = [ "open-fprintd-suspend.service" ];
        });

    # python-validity's own dbus service holds a libusb handle to the sensor that
    # goes stale across suspend (the USB device re-enumerates on resume). Its
    # matching "resume" hook (open-fprintd-resume.service) tries to fix this via
    # a graceful D-Bus Resume() call, but python-validity doesn't implement that
    # RPC in a way that actually reopens the device - it just crashes trying to
    # use the dead handle (usb.core.USBError: [Errno 19] No such device). The
    # only reliable fix is to force the driver process to restart so it opens
    # the sensor fresh.
    systemd.services.python-validity-resume = {
      description = "Restart python-validity to reopen the fingerprint sensor after resume";
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.systemd}/bin/udevadm settle";
        ExecStart = "${pkgs.systemd}/bin/systemctl restart python3-validity.service open-fprintd.service";
      };
    };

    networking.hostName = "noshiro";
  };
}
