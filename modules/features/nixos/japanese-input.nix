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
        ibus.engines = [
          # Qt >= 6.12 uic rejects class names with a leading "::"
          (pkgs.ibus-engines.mozc-ut.overrideAttrs (old: {
            postPatch = old.postPatch + ''
              substituteInPlace src/gui/dictionary_tool/dictionary_tool.ui \
                --replace-fail '"::mozc::' '"mozc::' \
                --replace-fail "<class>::mozc::" "<class>mozc::"
            '';
          }))
        ];
      };
    };
}
