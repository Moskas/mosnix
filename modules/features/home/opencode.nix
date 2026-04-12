{
  flake.homeModules.opencode =
    { pkgs, ... }:
    {
      config = {
        programs.opencode = {
          enable = true;
          package = pkgs.llm-agents.opencode;
        };
      };
    };
}
