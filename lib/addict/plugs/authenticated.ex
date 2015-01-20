defmodule Addict.Plugs.Authenticated do
  @moduledoc """
  Authenticated plug can be used to filter actions for users that are
  authenticated.
  """
  import Plug.Conn
  use Phoenix.Controller

  def init(options) do
    options
  end


  @doc """
  Call represents the use of the plug itself.

  When called, it will populate `conn` with the `current_user`, so it is
  possible to always retrieve the user via `conn[:current_user]`.

  In case the user is not logged in, it will redirect the request to
  the Application :addict :not_logged_in_url page. If none is defined, it will
  redirect to `/error`.
  """
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
