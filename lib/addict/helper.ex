defmodule Addict.Helper do
  def current_user(conn) do
    conn |> Plug.Conn.fetch_session |> Plug.Conn.get_session(:current_user)
  end

  def is_logged_in(conn) do
    current_user(conn) != "null"
  end

  def router_helper do
    Addict.Configs.repo
    |> to_string
    |> String.split(".")
    |> Enum.at(0)
    |> String.to_char_list
    |> :string.concat('.Router.Helpers')
    |> to_string
  end
end
