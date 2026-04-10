{
  flake.nixosModules.common =
    { pkgs, lib, ... }:
    {
      config = {
        services.tailscale = {
          enable = true;
        };
      };
    };
}
