{
  flake.nixosModules.commonWorkstation = {
    config = {
      services.fwupd.enable = true;
    };
  };
}
