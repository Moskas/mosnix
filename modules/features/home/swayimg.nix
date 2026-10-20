{
  flake.homeModules.swayimg =
    { config, ... }:
    {
      config = {
        programs.swayimg = {
          enable = true;
          # Terminess ships embedded 1-bit bitmap strikes at 12-24px (even) plus 28 and 32px;
          # swayimg copies glyphs as 8-bit gray, so those sizes render as garbage. Keep
          # the size off the strike list so FreeType rasterizes the outlines instead.
          initLua = ''
            swayimg.text.font = "${config.stylix.fonts.monospace.name}"
            swayimg.text.size = 25
          '';
        };
      };
    };
}
