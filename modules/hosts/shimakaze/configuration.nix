{ self, inputs, ... }:

{

  flake.nixosConfigurations.shimakaze = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.shimakaze
      inputs.wsl.nixosModules.wsl
    ];
  };
  flake.nixosModules.shimakaze =
    { pkgs, lib, ... }:
    {
      imports = [
        #"${modulesPath}/profiles/minimal.nix"
      ];

      wsl = {
        enable = true;
        wslConf = {
          automount.root = "/mnt";
          boot.command = "cd ~ && tx";
        };
        #automountPath = "/mnt";
        defaultUser = "moskas";
        startMenuLaunchers = true;

        # Enable native Docker support
        # docker-native.enable = true;

        useWindowsDriver = true;

        # Enable integration with Docker Desktop (needs to be installed)
        # docker-desktop.enable = true;
        wslConf.network.generateResolvConf = false;
      };

      #environment.noXlibs = false;

      networking = {
        hostName = "shimakaze";
        nameservers = [ "1.1.1.1" ];
      };

      time.timeZone = "Europe/Warsaw";

      services = {
      };

      programs.nix-ld.enable = true;

      system.stateVersion = "22.05";
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
