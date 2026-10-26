{ self, inputs, ... }:

{
  flake.nixosConfigurations.akashi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.akashi
    ];
  };
  flake.nixosModules.akashi =
    { lib, ... }:
    {
      imports = [
        self.nixosModules.commonWorkstation
        self.nixosModules.laptop
        self.nixosModules.vm-test
        self.nixosModules.lightweight
        self.nixosModules.niri
        self.nixosModules.japanese-input
        inputs.stylix.nixosModules.stylix
        self.nixosModules.stylixConfig
      ];

      moskas = {
        desktop.bar.position = "bottom";
        fonts.sizes = {
          desktop = 12;
          terminal = 12;
          popups = 12;
          applications = 12;
        };
      };

      home-manager.users.moskas = {
        # GMA 950: GLES 2.0 only, no hardware video decode
        programs.mpv.config = {
          profile = "fast";
          vo = lib.mkForce "gpu";
          hwdec = lib.mkForce "no";
          ytdl-format = "bv*[height<=480]+ba/b[height<=480]";
        };

        # ranger defaults assume kitty
        programs.ranger.settings.preview_images_method = lib.mkForce "sixel";
        xdg.desktopEntries.ranger.exec = lib.mkForce "foot --app-id ranger ranger %F";

        wayland.windowManager.sway.config.input."type:keyboard" = {
          xkb_layout = "jp";
          xkb_options = "lv3:ralt_switch";
        };
      };

      networking.hostName = "akashi";

      # ThinkPad X60 — legacy BIOS only, no UEFI
      # Override the systemd-boot defaults from the common module.
      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = lib.mkForce false;
        grub = {
          enable = true;
          # disko config sets this one automatically
          # device = "/dev/sda";
          enableCryptodisk = true;
        };
      };

      zramSwap.enable = true;

      services.tlp.settings = {
        # CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_MAX_FREQ_ON_AC = 1833000; # TODO verify with `cpufreq-info`
        CPU_SCALING_MAX_FREQ_ON_BAT = 1200000;
        CPU_SCALING_MIN_FREQ_ON_AC = 800000;
        CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
        # SATA link drops under write load with power management enabled
        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "max_performance";
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "on";
      };

      services.thinkfan.enable = true;

      # GPU — Intel 945GM framebuffer + power-saving
      boot.kernelParams = [
        "i915.enable_fbc=1"
        "i915.lvds_downclock=1"
        "i915.fastboot=1"
        "nowatchdog"
        "mitigations=off"
        # ICH7 SATA: NCQ writes fail with ATA bus errors (PHYRdyChg) on this drive
        "libata.force=noncq,1.5Gbps"
      ];

      # WiFi — stock Intel 3945ABG
      # ThinkPad hotkeys — enable volume buttons etc.
      boot.extraModprobeConfig = ''
        options iwl3945 power_save=0
        options thinkpad_acpi hotkey_mask=0x00fdffff
      '';

      # hardware.intel-undervolt = {
      #   enable = true;
      #   undervolt = { "CPU" = -100; };
      # };
    };
}
