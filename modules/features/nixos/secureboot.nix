{ inputs, ... }:
{
  flake.nixosModules.secureboot =
    { lib, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      config = {
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };
        };

        boot.loader.systemd-boot.enable = lib.mkForce false;
      };
    };
}
