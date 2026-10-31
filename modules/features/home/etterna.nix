{
  flake.homeModules.etterna =
    { inputs, ... }:
    {
      imports = [ inputs.mospkgs.homeManagerModules.etterna ];
      config = {
        mospkgs.programs.etterna.enable = true;
      };
    };
}
