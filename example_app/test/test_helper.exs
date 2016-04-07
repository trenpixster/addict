ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ExampleApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ExampleApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ExampleApp.Repo)

