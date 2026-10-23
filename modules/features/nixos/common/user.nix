{
  flake.nixosModules.common =
    {
      pkgs,
      lib,
      ...
    }:
    {
      config = {
        users.users.moskas = {
          isNormalUser = true;
          description = "Moskas";
          shell = lib.mkForce pkgs.zsh;
          extraGroups = [ "wheel" ];
          initialHashedPassword = "";
        };
        programs.zsh.enable = true;
        programs.nano.enable = false;
      };
    };
}
