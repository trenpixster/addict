defmodule Addict.View do
  import Plug.Conn

  @moduledoc """
    Addict helper view functions to be used on templates
   """

  @moduledoc """
   checks if user is logged in, returns true if so,
    and false if not
  """
  def logged_in(conn) do
    !!get_session conn, :current_user
  end

  @moduledoc """
   gets user model properties
  """
  def get_user(conn, prop) do
    user = get_session conn, :current_user
    user_prop(user, prop)
  end

  defp user_prop(nil, _) do
    nil
  end

  defp user_prop(user, prop) do
    Map.get user, prop
  end

end
