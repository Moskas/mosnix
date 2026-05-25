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
        self.nixosModules.moskasHomeManager
        self.nixosModules.japanese-input
      ];

      networking.hostName = "akashi";

      # ThinkPad X60 — legacy BIOS only, no UEFI
      # Override the systemd-boot defaults from the common module.
      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = lib.mkForce false;
        grub = {
          enable = true;
          device = "/dev/sda";
          enableCryptodisk = true;
        };
      };

      # ──────────────────────────────────────────────
      # Memory — X60 maxes at ~3 GB; compressed RAM is critical
      # ──────────────────────────────────────────────
      zramSwap.enable = true;

      # ──────────────────────────────────────────────
      # CPU / Power — always save power for heat & noise
      # ──────────────────────────────────────────────
      services.tlp.settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_MAX_FREQ_ON_AC = 1833000; # TODO verify with `cpufreq-info`
        CPU_SCALING_MAX_FREQ_ON_BAT = 1200000;
        CPU_SCALING_MIN_FREQ_ON_AC = 800000;
        CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
      };

      # ──────────────────────────────────────────────
      # Fan control
      # ──────────────────────────────────────────────
      services.thinkfan.enable = true;

      # ──────────────────────────────────────────────
      # GPU — Intel 945GM framebuffer + power-saving
      # Performance — personal device, no mitigations
      # ──────────────────────────────────────────────
      boot.kernelParams = [
        "i915.enable_fbc=1"
        "i915.lvds_downclock=1"
        "i915.fastboot=1"
        "nowatchdog"
        "mitigations=off"
      ];

      # ──────────────────────────────────────────────
      # WiFi — stock Intel 3945ABG
      # ──────────────────────────────────────────────
      boot.extraModprobeConfig = ''
        options iwl3945 power_save=0
      '';
    };
}
