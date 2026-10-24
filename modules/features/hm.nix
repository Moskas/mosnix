{ inputs, self, ... }:
{
  flake.nixosModules.moskasHomeManager =
    { config, lib, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
        self.nixosModules.moskasOptions
        self.nixosModules.moskasOverlays
      ];

      # Hosts that skip `common` (e.g. the WSL host) still get a usable
      # nixpkgs for the moskas home.
      nixpkgs.config.allowUnfree = lib.mkDefault true;

      # Prebuilt CUDA-enabled packages (e.g. the CUDA OBS build).
      nix.settings = lib.mkIf config.moskas.obs.cuda {
        substituters = [ "https://cache.nixos-cuda.org" ];
        trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };

      home-manager = {
        users."moskas" = {
          imports = [
            self.homeModules.moskasOptions
            # Mirror the settings knobs so hosts set every `moskas.*` value
            # once, at the top level of their NixOS module.
            {
              moskas = {
                colorscheme = lib.mkDefault config.moskas.colorscheme;
                desktop.bar = {
                  position = lib.mkDefault config.moskas.desktop.bar.position;
                  layout = {
                    start = lib.mkDefault config.moskas.desktop.bar.layout.start;
                    center = lib.mkDefault config.moskas.desktop.bar.layout.center;
                    end = lib.mkDefault config.moskas.desktop.bar.layout.end;
                  };
                  groups = lib.mkDefault config.moskas.desktop.bar.groups;
                };
                obs.cuda = lib.mkDefault config.moskas.obs.cuda;
                fonts = {
                  mono = {
                    package = lib.mkDefault config.moskas.fonts.mono.package;
                    name = lib.mkDefault config.moskas.fonts.mono.name;
                  };
                  sizes = lib.mkDefault config.moskas.fonts.sizes;
                };
              };
            }
          ];

          home = {
            username = "moskas";
            homeDirectory = "/home/moskas";
            stateVersion = "26.05";
          };
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };
    };

}
