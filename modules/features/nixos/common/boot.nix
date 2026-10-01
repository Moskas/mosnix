{
  flake.nixosModules.common = { pkgs, lib, ... }: {
    config = {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
        loader = {
          systemd-boot = {
            enable = true;
          };
          efi.canTouchEfiVariables = true;
        };
      };
      environment.systemPackages = with pkgs; [ linuxKernel.packages.linux_xanmod_latest.cpupower ];
    };
  };
}
