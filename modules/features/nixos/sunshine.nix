{
  flake.nixosModules.sunshine = {
    config = {
      services.sunshine = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
