{
  flake.nixosModules.ly = {
    config = {
      services.displayManager.ly.enable = true;
    };
  };
}
