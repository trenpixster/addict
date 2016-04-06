defmodule Addict.Interactors.DestroySession do
  import Plug.Conn

  def call(conn) do
    conn = conn
          |> fetch_session
          |> delete_session(:current_user)
          |> assign(:current_user, nil)
    {:ok, conn}
  end

end
