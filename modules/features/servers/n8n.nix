{
  flake.nixosModules.n8n = {
    config =
      { lib, config, ... }:
      {
        services.n8n = {
          enable = true;
          openFirewall = true;
          environment = {
            N8N_RUNNERS_AUTH_TOKEN_FILE = "/var/lib/n8n/auth";
            N8N_MCP_ENABLED = "true";
            N8N_MCP_SERVER_MODE = "sse";
          };
          taskRunners = {
            enable = true;
            runners = {
              javascript = {
                enable = true;
                command = lib.getExe' config.services.n8n.package "n8n-task-runner";
                healthCheckPort = 5681;
              };
              python = {
                enable = true;
                command = lib.getExe' config.services.n8n.package "n8n-task-runner-python";
                healthCheckPort = 5682;
              };
            };
          };
        };
      };
  };

}
