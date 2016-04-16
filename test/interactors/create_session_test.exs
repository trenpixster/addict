defmodule CreateSessionTest do
  alias Addict.Interactors.CreateSession
  use ExUnit.Case, async: true
  use Plug.Test

  @session_opts Plug.Session.init [
      store: :cookie,
      key: "_test",
      encryption_salt: "abcdefgh",
      signing_salt: "abcdefgh"
    ]

  test "it adds the :current_user key to the session" do
    fake_user = %{id: 123, email: "john.doe@example.com"}

    conn = conn(:get, "/")
           |> Plug.Session.call(@session_opts)
           |> fetch_session

    assert Plug.Conn.get_session(conn, :current_user) == nil

    {:ok, conn} = CreateSession.call(conn, fake_user)

    assert Plug.Conn.get_session(conn, :current_user) == fake_user
  end

end
