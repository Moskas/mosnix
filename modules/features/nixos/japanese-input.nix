{
  flake.nixosModules.japanese-input =
    { pkgs, ... }:
    {
      services.xserver.xkb = {
        layout = "jp";
        options = "lv3:ralt_switch";
      };

      # fcitx5 speaks input-method-v2, which niri implements; ibus does not
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = [ (pkgs.fcitx5-mozc.override { mozc = pkgs.mozc-ut; }) ];
          settings.inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "jp";
              DefaultIM = "mozc";
            };
            "Groups/0/Items/0".Name = "keyboard-jp";
            "Groups/0/Items/1".Name = "mozc";
          };
        };
      };
    };
}
