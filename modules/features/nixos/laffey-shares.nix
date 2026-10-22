{
  # laffey's home directory and shared data disk over sshfs. Mounted by root
  # with this host's own key (~/.ssh/<hostname>, authorized on laffey via the
  # common ssh module), so it works on any host that has that key.
  flake.nixosModules.laffeyShares =
    { config, ... }:
    let
      options = [
        "nodev"
        "noatime"
        "allow_other"
        "default_permissions"
        "IdentityFile=/home/moskas/.ssh/${config.networking.hostName}"
        "_netdev"
        "nofail"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        # Mount on first access instead of at boot, so laptops away from the
        # tailnet don't stall booting, and unmount again once idle.
        "x-systemd.automount"
        "x-systemd.idle-timeout=10min"
        "x-systemd.mount-timeout=15s"
      ];
    in
    {
      config = {
        fileSystems = {
          "/media/Laffey" = {
            device = "moskas@laffey:/home/moskas";
            fsType = "sshfs";
            inherit options;
          };
          "/media/Shared" = {
            device = "moskas@laffey:/mnt/disk2";
            fsType = "sshfs";
            inherit options;
          };
        };
        # The mounts run as root, so laffey's host key must be known
        # system-wide or the first mount fails host key verification.
        programs.ssh.knownHosts.laffey.publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPFG/ozAVIMOvm8OsjCfpXioHxpZP3Ndl3DJw6omRUm";
      };
    };
}
