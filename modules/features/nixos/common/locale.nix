{
  flake.nixosModules.common =
    { lib, ... }:
    {
      config = {
        time.timeZone = "Europe/Warsaw";
        services.xserver.xkb = {
          layout = lib.mkDefault "us";
        };
        console.useXkbConfig = true;
        i18n = {
          defaultLocale = "pl_PL.UTF-8";
          extraLocales = [
            "ja_JP.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
        };
      };
    };
}
