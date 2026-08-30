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
        self.nixosModules.common
        self.nixosModules.commonWorkstation
        self.nixosModules.laptop
        self.nixosModules.moskasProfile
        self.nixosModules.japanese-input
      ];

      moskas.profile = "terminal";

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
      };

      services.thinkfan.enable = true;

      # GPU — Intel 945GM framebuffer + power-saving
      boot.kernelParams = [
        "i915.enable_fbc=1"
        "i915.lvds_downclock=1"
        "i915.fastboot=1"
        "nowatchdog"
        "mitigations=off"
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
