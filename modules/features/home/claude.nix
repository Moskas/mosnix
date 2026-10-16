{
  flake.homeModules.claude =
    { pkgs, ... }:
    {
      config = {
        programs.claude-code = {
          enable = true;
          package = pkgs.llm-agents.claude-code;
          settings = {
            advisorModel = "opus";
            includeCoAuthoredBy = false;
            enabledPlugins = {
              "rust-analyzer-lsp@claude-plugins-official" = true;
            };
            effortLevel = "medium";
            theme = "dark-ansi";
            permissions = {
              allow = [
                "Bash(git diff:*)"
                "Edit"
              ];
              ask = [
                "Bash(git push:*)"
              ];
            };
          };
        };

        # TODO Decide if it's needed at all
        # if so add check for desktop env before adding
        # home.packages = with pkgs.llm-agents; [ claude-desktop ];
      };
    };
}
