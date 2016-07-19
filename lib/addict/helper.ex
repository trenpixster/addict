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

  @doc """
  Utility helper for executing Config defined functions
  """

  def exec(nil, _) do
    nil
  end

  def exec({mod, func}, args) do
    :erlang.apply mod, func, args
  end

  def exec(func, []) do
    :erlang.apply func, []
  end

  def exec(func, args) do
    :erlang.apply func, args
  end
end
