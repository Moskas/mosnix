{
  flake.nixosModules.n8n =
    { lib, config, ... }:
    {
      config = {
        services.n8n = {
          enable = true;
          openFirewall = false;
          environment = {
            N8N_RUNNERS_AUTH_TOKEN_FILE = "/var/lib/n8n/auth";
            N8N_MCP_ENABLED = "true";
            N8N_MCP_SERVER_MODE = "sse";

            # Reached only via the tsnsrv `n8n` node; bind localhost and emit
            # correct external URLs (WEBHOOK_URL is baked into every webhook node).
            N8N_LISTEN_ADDRESS = "127.0.0.1";
            N8N_HOST = "n8n.taila32e5.ts.net";
            N8N_PROTOCOL = "https";
            N8N_EDITOR_BASE_URL = "https://n8n.taila32e5.ts.net/";
            WEBHOOK_URL = "https://n8n.taila32e5.ts.net/";
            N8N_PROXY_HOPS = "1";
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
