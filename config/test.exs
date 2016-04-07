use Mix.Config
config :addict, TestAddictRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "addict_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
