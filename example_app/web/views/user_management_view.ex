defmodule ExampleApp.UserManagementView do
  use ExampleApp.Web, :view
  def current_user(conn) do
     Addict.Helper.current_user(conn)
  end

  def is_logged_in(conn) do
    current_user(conn) != nil
  end

  def user_info(conn) do
    conn |> current_user |> Poison.encode!
  end
end
