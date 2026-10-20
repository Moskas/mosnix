{ self, ... }:
{
  # Base feature set for every host. Add a feature by importing its module
  # here; hosts that want something extra import it directly.
  flake.homeModules.terminal = {
    # Stable key so `graphical` (which imports this) and a NixOS host that
    # also pulls `terminal` in don't apply the feature modules twice.
    key = "moskas/terminal";

    imports = with self.homeModules; [
      moskasOptions
      atuin
      bat
      btop
      claude
      concord
      direnv
      emacs
      eza
      git
      jj
      nyaa
      ranger
      starship
      shinbun
      terminal-utils
      tmux
      zoxide
      zsh
    ];
  };

  flake.nixosModules.terminal = {
    imports = [
      self.nixosModules.moskasHomeManager
      self.nixosModules.common
    ];

    home-manager.users.moskas.imports = [ self.homeModules.terminal ];
  };
}
