defmodule Addict.Plugs.Authenticated do
  @moduledoc """
  Authenticated plug can be used to filter actions for users that are
  authenticated.
  """
  import Plug.Conn

  def init(options) do
    options
  end


  @doc """
  Call represents the use of the plug itself.

  When called, it will assign `current_user` to `conn`, so it is
  possible to always retrieve the user via `conn.assigns.current_user`.

  In case the user is not logged in, it will redirect the request to
  the Application :addict :not_logged_in_url page. If none is defined, it will
  redirect to `/error`.
  """
  def call(conn, _) do
    conn = fetch_session(conn)
    not_logged_in_url = Addict.Configs.not_logged_in_url || "/login"
    if is_logged_in(get_session(conn, :current_user)) do
      assign(conn, :current_user, get_session(conn, :current_user))
    else
      conn |> Phoenix.Controller.redirect(to: not_logged_in_url) |> halt
    end
  end

  def is_logged_in(user_session) do
    case user_session do
      nil -> false
      _   -> true
    end
  end

end
