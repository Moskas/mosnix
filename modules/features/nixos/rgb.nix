{
  flake.nixosModules.rgb = { pkgs, lib, ... }: {
    config = {
      services.hardware.openrgb = {
        enable = true;
        motherboard = lib.mkDefault "amd";
        startupProfile = lib.mkDefault "Red";
      };

      environment.systemPackages = with pkgs; [
        i2c-tools
      ];
    };
  };
}
