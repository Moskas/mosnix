{
  flake.nixosModules.common = {
    config = {
      services.tailscale = {
        enable = true;
      };
    };
  };
}
