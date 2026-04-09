{
  description = "Moskas' Dendritic Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/parts.nix
        ./modules/common/default.nix
        ./modules/features/nix.nix
        ./modules/features/home-manager.nix
        ./modules/features/home/zsh.nix
        ./modules/hosts/shimakaze/configuration.nix
        ./modules/hosts/shimakaze/hardware.nix
        ./modules/hosts/shimakaze/home.nix
      ];
    };
}
