{
  flake.homeModules.yotei =
    { inputs, system, ... }:
    {
      config = {
        imports = [ inputs.yotei.homeManagerModules.default ];

        services.yotei = {
          enable = true;
          package = inputs.yotei.packages.${system}.default;
          settings = {
            agenda_files = [
              "~/Documents/Org/Agenda/todo.org"
              "~/Documents/Org/Agenda/tasks.org"
              "~/Documents/Org/Me/habits.org"
            ];
            notifications = {
              pre_notify_minutes = 15;
              deadline_pre_notify_minutes = 60;
            };
            daemon = {
              poll_interval_secs = 60;
            };
          };
        };
      };
    };
}
