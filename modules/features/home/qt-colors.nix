{
  # Fixes for stylix's Qt theming outside a Plasma session.
  flake.homeModules.qtColors =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      c = config.lib.stylix.colors;

      findPackage =
        prefix: packages:
        lib.findFirst (
          p: lib.hasPrefix prefix (p.name or "")
        ) (throw "qtColors: ${prefix} not found") packages;

      kdeTheme = findPackage "stylix-kde-theme" config.home.packages;
      kvantumTheme = findPackage "base16-kvantum" config.qt.kvantum.themes;

      slug = lib.concatStrings (lib.filter lib.isString (builtins.split "[^a-zA-Z]" c.scheme));

      # Stylix fills pressed/toggled buttons and item views with base04 but
      # keeps base05 text and icons on top, which is unreadable. Use the same
      # solid states as the Firefox userChrome: base02 hover, base03 active.
      kvantumPatched = pkgs.runCommandLocal "base16-kvantum-patched" { } ''
        dir=share/Kvantum/Base16Kvantum
        mkdir -p $out/$dir
        cp ${kvantumTheme}/$dir/Base16Kvantum.kvconfig $out/$dir/
        awk '
          match($0, /id="[^"]*"/) { id = substr($0, RSTART + 4, RLENGTH - 5) }
          id ~ /^(button|tbutton|itemview)-(pressed|toggled)/ { gsub(/#${c.base04}/, "#${c.base03}") }
          id ~ /^itemview-focused/ { gsub(/#${c.base04}/, "#${c.base02}") }
          { print }
        ' ${kvantumTheme}/$dir/Base16Kvantum.svg > $out/$dir/Base16Kvantum.svg
      '';
    in
    {
      config = lib.mkMerge [
        # Kirigami apps (EasyEffects, etc.) read their palette from the
        # [Colors:*] groups in kdeglobals. Stylix only writes those via
        # plasma-apply-lookandfeel, which needs a running Plasma session, so
        # outside Plasma they fall back to Breeze. Ship stylix's generated
        # color scheme as the user kdeglobals instead.
        (lib.mkIf config.stylix.targets.kde.enable {
          xdg.configFile."kdeglobals".source = "${kdeTheme}/share/color-schemes/${slug}.colors";
        })

        # Mirrors home-manager's qt.kvantum.themes link, with stylix's theme
        # swapped for the patched one.
        (lib.mkIf (config.stylix.targets.qt.enable && config.qt.style.name == "kvantum") {
          xdg.configFile."Kvantum".source = lib.mkForce (
            pkgs.symlinkJoin {
              name = "kvantum-themes";
              paths = map (p: if p == kvantumTheme then kvantumPatched else p) config.qt.kvantum.themes;
              stripPrefix = "/share/Kvantum";
            }
          );
        })
      ];
    };
}
