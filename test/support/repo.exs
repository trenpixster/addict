defmodule TestAddictRepo do
  use Ecto.Repo, otp_app: :addict, pool: Ecto.Adapters.SQL.Sandbox
end
