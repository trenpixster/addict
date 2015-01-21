defmodule AuthenticatedTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Addict.Plugs.Authenticated, as: Auth

  @session_opts Plug.Session.init [
    store: :cookie,
    key: "_test",
    encryption_salt: "abcdefgh",
    signing_salt: "abcdefgh"
  ]

  @authenticated_opts Auth.init []

  setup_all do
    conn = conn(:get, "/")
      |> Map.put(:secret_key_base, String.duplicate("a", 64))
      |> Plug.Session.call(@session_opts)
      |> fetch_session

    {:ok, %{conn: conn}}
  end

  test "not_logged_in_url" do
    assert Auth.not_logged_in_url == "/error"
  end

  test "assign current_user when logged in", context do
    conn = context.conn
      |> put_session(:logged_in, true)
      |> put_session(:current_user, "bob")

    refute Map.has_key?(conn.assigns, :current_user)

    conn = Auth.call(conn, @authenticated_opts)
    assert conn.assigns.current_user == "bob"
  end

  test "redirect when not logged in", context do
    conn = context.conn
      |> put_session(:logged_in, false)
      |> Auth.call(@authenticated_opts)

    assert conn.halted
    assert conn.status in 300..399
    assert get_resp_header(conn, "Location") == [Auth.not_logged_in_url]
  end
end
