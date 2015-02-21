defmodule ExampleApp.PageController do
  use Phoenix.Controller
  plug Addict.Plugs.Authenticated when action in [:show]

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _) do
    user = get_session conn, :user
    IO.inspect user
    render conn, "logged_in.html"
  end

  def forbidden(conn,_) do
    render conn, "error.html"
  end
end
