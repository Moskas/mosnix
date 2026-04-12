{
  flake.homeModules.emacs =
    { pkgs, inputs, ... }:
    {
      imports = [ inputs.emacs-overlay.overlay ];
      config = {
        programs.emacs = {
          enable = true;
          package = pkgs.emacs-unstable-pgtk;
          extraPackages =
            epkgs: with epkgs; [
              vterm-toggle
              vterm
              mu4e
            ];
        };

        services.emacs = {
          client.enable = true;
          defaultEditor = true;
          startWithUserSession = "graphical";
        };

        home = {
          packages = with pkgs; [
            ispell
            aspell
            ripgrep
            (pkgs.writeScriptBin "eww" ''
              if [ -z "$1" ]; then
                  echo "Usage: eww <URL>"
                  exit 1
              fi
              ${pkgs.emacs-unstable-pgtk}/bin/emacs -nw --eval "(eww \"$1\")"
            '')
          ];
        };
      };
    };
}
