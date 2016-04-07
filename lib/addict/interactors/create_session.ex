defmodule Addict.Interactors.CreateSession do
  import Plug.Conn

  @doc """
  Adds `user` as `:current_user` to the session in `conn`

  Returns `{:ok, conn}`
  """
  def call(conn, user) do
    conn = conn
    |> fetch_session
    |> put_session(:current_user, Addict.Presenter.strip_all(user))
    {:ok, conn}
  end
end
