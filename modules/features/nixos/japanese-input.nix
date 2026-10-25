{
  flake.nixosModules.japanese-input =
    { pkgs, ... }:
    let
      # Qt >= 6.12 uic rejects class names with a leading "::"
      mozc-ut = pkgs.mozc-ut.overrideAttrs (old: {
        postPatch = old.postPatch + ''
          substituteInPlace src/gui/dictionary_tool/dictionary_tool.ui \
            --replace-fail '"::mozc::' '"mozc::' \
            --replace-fail "<class>::mozc::" "<class>mozc::"
        '';
      });
    in
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
          addons = [ (pkgs.fcitx5-mozc.override { mozc = mozc-ut; }) ];
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
