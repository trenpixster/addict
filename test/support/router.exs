defmodule TestAddictRouter do
  use Phoenix.Router
  use Addict.RoutesHelper

  pipeline :addict_api_test do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/" do
    addict :routes
  end
end
