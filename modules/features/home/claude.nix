{ lib, ... }:
{
  flake.homeModules.claude =
    { pkgs, ... }:
    let
      # Every subdirectory of ./claude/skills is a skill; linked one by one so
      # ~/.claude/skills stays writable for skills synced from claude.ai
      skillsDir = ./claude/skills;
      skills = lib.mapAttrs (name: _: skillsDir + "/${name}") (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDir)
      );
    in
    {
      config = {
        programs.claude-code = {
          enable = true;
          package = pkgs.llm-agents.claude-code;
          context = ./claude/context.md;
          inherit skills;
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
