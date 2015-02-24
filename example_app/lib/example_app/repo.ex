defmodule ExampleApp.Repo do
  use Ecto.Repo,
    otp_app: :example_app,
    adapter: Ecto.Adapters.Postgres
end
