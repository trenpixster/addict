Logger.configure(level: :info)
ExUnit.start

Code.require_file "./support/schema.exs", __DIR__
Code.require_file "./support/repo.exs", __DIR__
Code.require_file "./support/router.exs", __DIR__
Code.require_file "./support/migrations.exs", __DIR__

defmodule Addict.RepoSetup do
  use ExUnit.CaseTemplate
  setup_all do
    Ecto.Adapters.SQL.begin_test_transaction(TestAddictRepo, [])
    on_exit fn -> Ecto.Adapters.SQL.rollback_test_transaction(TestAddictRepo, []) end
    :ok
  end

  setup do
    Ecto.Adapters.SQL.restart_test_transaction(TestAddictRepo, [])
    :ok
  end
end

defmodule Addict.SessionSetup do
  def with_session(conn) do
    session_opts = Plug.Session.init(store: :cookie, key: "_app",
                                     encryption_salt: "abc", signing_salt: "abc")
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(session_opts)
    |> Plug.Conn.fetch_session()
  end
end

_ = Ecto.Storage.down(TestAddictRepo)
_ = Ecto.Storage.up(TestAddictRepo)

{:ok, _pid} = TestAddictRepo.start_link
_ = Ecto.Migrator.up(TestAddictRepo, 0, TestAddictMigrations, log: false)
Process.flag(:trap_exit, true)
