{
  flake.nixosModules.common = {
    config = {
      system = {
        stateVersion = "25.11";
        build.images = [ "iso" ];
      };
    };
  };
}
