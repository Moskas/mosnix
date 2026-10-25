{
  # Binary caches shared by every host and the installer ISO, so installs
  # substitute the same paths the hosts themselves would
  flake.nixosModules.caches = {
    key = "moskas/caches";
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://moskas.cachix.org"
        "https://noctalia.cachix.org"
        # Prebuilt CUDA-enabled packages (e.g. the CUDA OBS build)
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "moskas.cachix.org-1:LcyLityXMILC1SenFSMMt7JgvUEOvS38Kza6b96TQEw="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
