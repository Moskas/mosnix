{
  flake.nixosModules.commonWorkstation = {
    config = {
      services.gvfs.enable = true;
    };
  };
}
