defmodule Addict.Interactors.DestroySession do
  import Plug.Conn
  @doc """
  Removes `:current_user` from the session in `conn`

  Returns `{:ok, conn}`
  """

  def call(conn) do
    conn = conn
          |> fetch_session
          |> delete_session(:current_user)
          |> assign(:current_user, nil)
    {:ok, conn}
  end

end
