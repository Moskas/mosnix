{
  flake.nixosModules.common =
    { pkgs, lib, ... }:
    {
      config = {
        users.users.moskas = {
          isNormalUser = true;
          description = "Moskas";
          shell = lib.mkForce pkgs.zsh;
          extraGroups = [ "wheel" ];
          initialPassword = "nix";
        };
        programs.zsh.enable = true;
      };
    };
}
