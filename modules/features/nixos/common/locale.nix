{
  flake.nixosModules.common = {
    config = {
      time.timeZone = "Europe/Warsaw";
      i18n = {
        defaultLocale = "pl_PL.UTF-8";
        extraLocales = [
          "jp_JP.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
        ];
      };
    };
  };
}
