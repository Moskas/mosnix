{
  flake.nixosModules.japanese-input =
    { pkgs, ... }:
    {
      services.xserver.xkb = {
        layout = "jp";
        options = "lv3:ralt_switch";
      };

      i18n.inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ mozc-ut ];
      };
    };
}
