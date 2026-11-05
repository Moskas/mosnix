{
  flake.nixosModules.ddcutil = {
    config = {
      # Loads i2c-dev and grants /dev/i2c-* access to users with a local seat
      hardware.i2c.enable = true;
    };
  };
}
