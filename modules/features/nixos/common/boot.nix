{
  flake.nixosModules.common = {
    config = {
      boot = {
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
