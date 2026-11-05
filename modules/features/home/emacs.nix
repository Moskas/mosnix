{ inputs, ... }:
{
  flake.homeModules.emacs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Store paths handed to the Doom config without putting the tools on PATH
      nixPaths = pkgs.writeTextDir "nix-paths.el" ''
        ;;; nix-paths.el -*- lexical-binding: t; -*-
        (setq treemacs-python-executable "${pkgs.python3}/bin/python3")
      '';

      # Base16 schemes with a hand-tuned doom-themes counterpart
      doomThemes = {
        "ayu-dark" = "doom-ayu-dark";
        "ayu-light" = "doom-ayu-light";
        "ayu-mirage" = "doom-ayu-mirage";
        "dracula" = "doom-dracula";
        "gruvbox-dark-hard" = "doom-gruvbox";
        "gruvbox-dark-medium" = "doom-gruvbox";
        "gruvbox-dark-soft" = "doom-gruvbox";
        "gruvbox-light-medium" = "doom-gruvbox-light";
        "horizon-dark" = "doom-horizon";
        "material-palenight" = "doom-palenight";
        "monokai" = "doom-monokai-classic";
        "nord" = "doom-nord";
        "nord-light" = "doom-nord-light";
        "onedark" = "doom-one";
        "one-light" = "doom-one-light";
        "solarized-dark" = "doom-solarized-dark";
        "solarized-light" = "doom-solarized-light";
        "tokyo-night-dark" = "doom-tokyo-night";
        "tomorrow-night" = "doom-tomorrow-night";
        "zenburn" = "doom-zenburn";
      };

      inherit (config.moskas) colorscheme;
      stylix = config.lib.stylix.colors.withHashtag or null;
      # Unmapped schemes get a theme generated from the stylix palette
      useBase16 = !(doomThemes ? ${colorscheme}) && stylix != null;
      theme = if useBase16 then "base16-stylix" else doomThemes.${colorscheme} or "doom-gruvbox";

      # Doom puts $DOOMDIR/themes on custom-theme-load-path
      base16Theme = pkgs.writeTextDir "themes/base16-stylix-theme.el" (
        with stylix;
        ''
          ;;; base16-stylix-theme.el -*- lexical-binding: t; -*-
          (require 'base16-theme)
          (deftheme base16-stylix)
          (base16-theme-define 'base16-stylix
            '(:base00 "${base00}" :base01 "${base01}" :base02 "${base02}" :base03 "${base03}"
              :base04 "${base04}" :base05 "${base05}" :base06 "${base06}" :base07 "${base07}"
              :base08 "${base08}" :base09 "${base09}" :base0A "${base0A}" :base0B "${base0B}"
              :base0C "${base0C}" :base0D "${base0D}" :base0E "${base0E}" :base0F "${base0F}"))
          (provide-theme 'base16-stylix)
        ''
      );

      # Fontconfig name with size in points; a font-spec with :weight breaks
      # doom-big-font-mode on fonts whose Regular style reports another weight
      font = "${config.moskas.fonts.mono.name}-${toString config.moskas.fonts.sizes.terminal}";

      # Loaded after the config's fallback theme and font, so moskas.* wins
      nixStyle = pkgs.writeTextDir "nix-style.el" ''
        ;;; nix-style.el -*- lexical-binding: t; -*-
        (setq doom-theme '${theme}
              doom-font "${font}"
              doom-variable-pitch-font "${font}")
      '';

      emacs = config.programs.doom-emacs.finalEmacsPackage;

      # Terminal frame when attached to a tty or without a display, GUI frame otherwise
      editor = pkgs.writeShellScript "editor" ''
        client=${lib.getBin config.services.emacs.package}/bin/emacsclient
        if [ -t 0 ] && [ -t 1 ] || [ -z "$WAYLAND_DISPLAY$DISPLAY" ]; then
          exec "$client" --tty "$@"
        fi
        exec "$client" --create-frame "$@"
      '';
    in
    {
      imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

      config = {
        programs.doom-emacs = {
          enable = true;
          experimentalFetchTree = true;
          emacs = pkgs.emacs-unstable-pgtk;
          doomDir = pkgs.symlinkJoin {
            name = "doom-dir";
            paths = [
              ./emacs/doom
              nixPaths
              nixStyle
            ]
            ++ lib.optional useBase16 base16Theme;
          };
          extraPackages =
            epkgs:
            [
              epkgs.mu4e
              epkgs.treesit-grammars.with-all-grammars
            ]
            ++ lib.optional useBase16 epkgs.base16-theme;
          # Inherited by every Emacs subprocess, vterm included
          extraBinPackages = with pkgs; [
            git
            ripgrep
            fd
            nixd
            nixfmt
          ];
        };

        programs.zsh.shellAliases.mg = "emacs -nw --eval '(magit)'";

        services.emacs = {
          enable = true;
          # EDITOR wrapper has no fallback, start the daemon on first connect
          socketActivation.enable = true;
          client.enable = true;
          startWithUserSession = "graphical";
        };

        home = {
          sessionVariables = {
            EDITOR = editor;
            VISUAL = editor;
          };

          # Doom profile dirs aren't created up front, packages like spell-fu
          # fail on make-directory without parents
          activation.doomProfileDirs =
            let
              profile = config.programs.doom-emacs.profileName;
            in
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              run mkdir -p \
                "${config.xdg.dataHome}/doom/${profile}" \
                "${config.xdg.cacheHome}/doom/${profile}" \
                "${config.xdg.stateHome}/doom/${profile}"
            '';

          packages = with pkgs; [
            (aspellWithDicts (dicts: [
              dicts.en
              dicts.pl
            ]))
            (pkgs.writeScriptBin "eww" ''
              if [ -z "$1" ]; then
                  echo "Usage: eww <URL>"
                  exit 1
              fi
              ${emacs}/bin/emacs -nw --eval "(eww \"$1\")"
            '')
          ];
        };
      };
    };
}
