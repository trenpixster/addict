defmodule Addict.Helper do
@moduledoc """
Addict Helper functions
"""

  @doc """
  Returns the current user in session in a Hash
  """
  def current_user(conn) do
    conn |> Plug.Conn.fetch_session |> Plug.Conn.get_session(:current_user)
  end

  @doc """
  Verifies if user is logged in

  Returns a boolean
  """
  def is_logged_in(conn) do
    current_user(conn) != nil
  end
end
