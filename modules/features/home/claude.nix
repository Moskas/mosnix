{
  flake.homeModules.claude =
    { pkgs, ... }:
    {
      config = {
        programs.claude-code = {
          enable = true;
          package = pkgs.llm-agents.claude-code;
        };
        home.packages = with pkgs.llm-agents; [ claude-desktop ];
      };
    };
}
