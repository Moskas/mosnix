{
  flake.nixosModules.vm-test =
    { lib, ... }:
    {
      config = {
        virtualisation = {
          vmVariant = {
            virtualisation = {
              cores = 4;
              memorySize = 4096;
            };
            # Taken from https://github.com/donovanglover/nix-config/commit/0bf134297b3a62da62f9ee16439d6da995d3fbff
            # to enable Hyprland to work on a virtualized GPU.
            virtualisation.qemu.options = [
              "-device virtio-vga-gl"
              "-display sdl,gl=on,show-cursor=off"
              # Wire up pipewire audio
              "-audiodev pipewire,id=audio0"
              "-device intel-hda"
              "-device hda-output,audiodev=audio0"
            ];

            environment.sessionVariables = lib.mkVMOverride {
              WLR_NO_HARDWARE_CURSORS = "1";
            };
          };
        };
      };
    };
}
