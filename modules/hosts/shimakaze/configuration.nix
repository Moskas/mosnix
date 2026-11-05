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
        self.nixosModules.terminal
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

      home-manager.users.moskas.imports = [ self.homeModules.emacs ];

      boot.loader.systemd-boot.enable = lib.mkForce false;

      networking = {
        hostName = "shimakaze";
        networkmanager.enable = lib.mkForce false;
        nameservers = [ "1.1.1.1" ];
      };

      time.timeZone = "Europe/Warsaw";
      programs.nix-ld.enable = true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
