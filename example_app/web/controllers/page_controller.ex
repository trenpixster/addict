defmodule ExampleApp.PageController do
  use ExampleApp.Web, :controller
  plug Addict.Plugs.Authenticated when action in [:required_login]

  def index(%{method: "GET"} = conn, _params) do
    render conn, "index.html"
  end

  def index(%{method: "POST"} = conn, _params) do
    json conn, %{}
  end

  def required_login(conn, _params) do
    render conn, "required_login.html"
  end
end
