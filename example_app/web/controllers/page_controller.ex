defmodule ExampleApp.PageController do
  use ExampleApp.Web, :controller
  plug Addict.Plugs.Authenticated when action in [:show]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _) do
    user = get_session conn, :user
    IO.inspect user
    render conn, "logged_in.html"
  end

  def forbidden(conn,_) do
    render conn, "not_logged_in.html"
  end
end
