{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      config = {
        programs.niri.enable = true;
      };
    };
}
