{
  flake.nixosModules.common =
    { lib, ... }:
    {
      config = {
        boot = lib.mkDefault {
          loader = {
            systemd-boot = {
              enable = true;
            };
            efi.canTouchEfiVariables = true;
          };
        };
      };
    };
}
