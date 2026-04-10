{ self, inputs, ... }:
{

  flake.homeModules.lf =
    { pkgs, ... }:
    {
      programs.lf = {
        enable = true;
      };
    };

}
