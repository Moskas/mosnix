{ self, inputs, ... }:
{

  flake.homeModules.zsh =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
    };

}
