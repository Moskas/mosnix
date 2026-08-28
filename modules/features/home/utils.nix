{
  flake.homeModules.terminal-utils = { pkgs, ... }: {
    # Misc. utils that don't have hm modules nor require any additionall config
    config = {
      home.packages = with pkgs; [
        dust
        duf
        unrar
        zip
        unzip
        kondo
      ];
    };
  };
}
