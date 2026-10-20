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

      emacs = config.programs.doom-emacs.finalEmacsPackage;
    in
    {
      imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

      config = {
        programs.doom-emacs = {
          enable = true;
          emacs = pkgs.emacs-unstable-pgtk;
          doomDir = pkgs.symlinkJoin {
            name = "doom-dir";
            paths = [
              inputs.doom-config
              nixPaths
            ];
          };
          extraPackages = epkgs: [
            epkgs.mu4e
            epkgs.treesit-grammars.with-all-grammars
          ];
          # Inherited by every Emacs subprocess, vterm included
          extraBinPackages = with pkgs; [
            git
            ripgrep
            fd
            nixd
            nixfmt
          ];
        };

        services.emacs = {
          client.enable = true;
          defaultEditor = true;
          startWithUserSession = "graphical";
        };

        home = {
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
            ispell
            aspell
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
