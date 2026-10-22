{
  flake.nixosModules.n8n =
    { lib, config, ... }:
    {
      config = {
        sops.secrets = {
          # Shared secret between n8n's task broker and its runners
          n8n_runners_auth_token = {
            mode = "0400";
          };
          # OPENAI_API_KEY=..., read by workflows via $env
          n8n_env = {
            mode = "0400";
          };
        };
        # Plain env vars for workflows; the module's *_FILE handling only
        # covers n8n's own settings, which read the *_FILE variant themselves.
        systemd.services.n8n.serviceConfig.EnvironmentFile = config.sops.secrets.n8n_env.path;
        services.n8n = {
          enable = true;
          openFirewall = false;
          environment = {
            # Loaded as a systemd credential by the module, never world-readable.
            # Do not add N8N_ENCRYPTION_KEY: the existing one lives in the
            # state dir and replacing it orphans every stored credential.
            N8N_RUNNERS_AUTH_TOKEN_FILE = config.sops.secrets.n8n_runners_auth_token.path;
            N8N_RUNNERS_TASK_REQUEST_TIMEOUT = "120";
            N8N_MCP_ENABLED = "true";
            N8N_MCP_SERVER_MODE = "sse";
            # Workflows call internal services (slide-renderer, etc.) and read $env
            N8N_SSRF_PROTECTION_ENABLED = "false";
            N8N_BLOCK_ENV_ACCESS_IN_NODE = "false";

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
