{ lib, inputs, ... }:
{
  # Data + helpers consumed by the home + nixos profile resolvers. Single
  # `flake.lib` definition site so flake-parts can merge it.
  flake.lib.moskas = {
    profiles =
      let
        # Every home feature module a profile may toggle. Keep in sync when a
        # feature module is added under modules/features/home/ (or the niri home
        # module in modules/features/nixos/niri.nix). Meta modules (moskasOptions,
        # moskasHome, gaming, profile-*) are deliberately absent.
        featureList = [
          "atuin"
          "bat"
          "btop"
          "carapace"
          "claude"
          "direnv"
          "easyeffects"
          "emacs"
          "eza"
          "firefox"
          "fuzzel"
          "git"
          "kitty"
          "lf"
          "mako"
          "mpd"
          "nixcord"
          "niri"
          "noctalia"
          "obs"
          "opencode"
          "prism"
          "qutebrowser"
          "ranger"
          "shinbun"
          "starship"
          "terminal-utils"
          "tickrs"
          "tmux"
          "wallpapers"
          "waybar"
          "yotei"
          "zathura"
          "zoxide"
          "zsh"
        ];

        # The `terminal` preset is the base; `graphical` layers GUI features on
        # top. `graphicalFeatures` equals the pre-refactor `full` import list.
        terminalFeatures = [
          "atuin"
          "bat"
          "btop"
          "eza"
          "git"
          "ranger"
          "starship"
          "shinbun"
          "terminal-utils"
          "tmux"
          "zoxide"
          "zsh"
        ];

        graphicalExtras = [
          "carapace"
          "claude"
          "direnv"
          "emacs"
          "easyeffects"
          "firefox"
          "fuzzel"
          "kitty"
          "mpd"
          "nixcord"
          "niri"
          "noctalia"
          "opencode"
          "prism"
          "tickrs"
          "wallpapers"
          "zathura"
        ];

        graphicalFeatures = terminalFeatures ++ graphicalExtras;

        mkHome = names: lib.genAttrs names (_: true);
      in
      {
        inherit featureList;
        presets = {
          terminal = {
            home = mkHome terminalFeatures;
          };
          graphical = {
            home = mkHome graphicalFeatures;
          };
        };
      };

    # nixpkgs for the standalone home configs, carrying the same overlays the
    # NixOS path applies via the common module.
    homePkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = [
        inputs.mospkgs.overlays.default
        inputs.emacs-overlay.overlay
        inputs.llm-agents.overlays.shared-nixpkgs
      ];
      config.allowUnfree = true;
    };
  };
}
