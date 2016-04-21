defmodule DestroySessionTest do
  alias Addict.Interactors.{CreateSession, DestroySession}
  use ExUnit.Case, async: true
  use Plug.Test

  @session_opts Plug.Session.init [
      store: :cookie,
      key: "_test",
      encryption_salt: "abcdefgh",
      signing_salt: "abcdefgh"
    ]

  test "it removes the :current_user key from the session" do
    fake_user = %{id: 123, email: "john.doe@example.com"}

    conn = conn(:get, "/")
           |> Plug.Session.call(@session_opts)
           |> fetch_session
    {:ok, conn} = CreateSession.call(conn, fake_user, TestAddictSchema)

    {:ok, conn} = DestroySession.call(conn)

    assert Plug.Conn.get_session(conn, :current_user) == nil
  end

end
