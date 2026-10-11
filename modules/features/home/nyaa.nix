{ inputs, ... }:
{
  flake.homeModules.nyaa = {
    imports = [ inputs.nyaa.homeManagerModule ];
    programs.nyaa.enable = true;
  };
}
