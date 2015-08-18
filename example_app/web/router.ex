defmodule ExampleApp.Router do
  use Addict.RoutesHelper
  use ExampleApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser # Use the default browser stack

    get "/", ExampleApp.PageController, :index
    get "/show", ExampleApp.PageController, :show
    get "/forbidden", ExampleApp.PageController, :forbidden

    addict :routes,
      logout: [path: "/logout", controller: ExampleApp.UserController, action: :signout],
      recover_password: "/password/recover",
      reset_password: "/password/reset"
  end
end
