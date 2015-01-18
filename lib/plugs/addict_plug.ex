defmodule AddictAuthenticated do
  import Plug.Conn
  use Phoenix.Controller

  def init(options) do
    options
  end

  def call(conn, _) do
    fetch_session(conn)

    if get_session(conn, :logged_in) do
      Map.put(conn, :current_user, get_session(conn, :current_user))
    else
      conn |> redirect(to: not_logged_in_url) |> halt
    end
  end

  def not_logged_in_url do
    Application.get_env(:addict, :not_logged_in_url) || "/error"
  end

end