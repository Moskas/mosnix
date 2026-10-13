{ inputs, ... }:
{
  # Support for the standalone `flake.homeConfigurations.<host>` outputs (home
  # activation without NixOS). Pair `standalone-base` with `terminal` or
  # `graphical` from homeModules.
  flake.homeModules.standalone-base = {
    home = {
      username = "moskas";
      homeDirectory = "/home/moskas";
      stateVersion = "26.05";
    };
  };

  # nixpkgs for the standalone home configs, carrying the same overlays the
  # NixOS path applies via the common module.
  flake.lib.moskas.homePkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [
      inputs.mospkgs.overlays.default
      inputs.emacs-overlay.overlay
      inputs.llm-agents.overlays.shared-nixpkgs
    ];
    config.allowUnfree = true;
  };
}
