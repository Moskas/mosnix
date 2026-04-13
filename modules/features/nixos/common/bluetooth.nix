{
  flake.nixosModules.common = {
    config = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      services.blueman.enable = true;
    };
  };
}
