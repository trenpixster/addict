defmodule Addict.Interactors.CreateSession do
  import Plug.Conn

  def call(conn, user) do
    conn = conn
    |> fetch_session
    |> put_session(:current_user, Addict.Presenter.strip_all(user))
    {:ok, conn}
  end
end
