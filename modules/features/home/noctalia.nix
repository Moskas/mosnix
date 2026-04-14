{
  flake.homeModules.noctalia =
    { inputs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];
      config = {
        programs.noctalia-shell = {
          enabble = true;
        };
      };
    };
}
