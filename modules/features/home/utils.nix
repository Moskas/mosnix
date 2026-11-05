{
  flake.homeModules.terminal-utils = { lib, pkgs, ... }: {
    # Misc. utils that don't have hm modules nor require any additionall config
    config = {
      # Overridden by the emacs module on hosts that import it
      home.sessionVariables = {
        EDITOR = lib.mkDefault "nvim";
        VISUAL = lib.mkDefault "nvim";
      };

      home.packages = with pkgs; [
        dust
        duf
        unrar
        zip
        unzip
        kondo
        neovim
      ];
    };
  };
}
