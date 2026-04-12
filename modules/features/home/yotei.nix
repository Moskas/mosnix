{
  flake.homeModules.yotei =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.yotei.homeManagerModules.default
      ];
      config = {
        services.yotei = {
          enable = true;
          package = pkgs.yotei;
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
