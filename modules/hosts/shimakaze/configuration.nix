{
  self,
  inputs,
  ...
}:

{
  flake.nixosConfigurations.shimakaze = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.shimakaze
    ];
  };
  flake.nixosModules.shimakaze =
    {
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.moskasHomeManager
        "${modulesPath}/profiles/minimal.nix"
        inputs.wsl.nixosModules.wsl
      ];
      wsl = {
        enable = true;
        defaultUser = "moskas";
        startMenuLaunchers = true;
        useWindowsDriver = true;
        wslConf.network.generateResolvConf = false;
      };
      networking = {
        hostName = "shimakaze";
        nameservers = [ "1.1.1.1" ];
      };

      time.timeZone = "Europe/Warsaw";
      programs.nix-ld.enable = true;

      system.stateVersion = "22.05";
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      home-manager.users.moskas = self.homeModules.moskasModule;
    };
}
