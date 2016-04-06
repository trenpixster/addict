defmodule ExampleApp.Router do
  use ExampleApp.Web, :router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :addict_routes do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug :put_layout, {Addict.AddictView, "addict.html"}

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :addict_api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :addict_routes
    # get "/register", Addict.AddictController, :register
    # get "/recover_password", Addict.AddictController, :recover_password
    # get "/reset_password", Addict.AddictController, :reset_password
    # get "/login", Addict.AddictController, :login
    addict :routes
  end

  scope "/" do
    pipe_through :browser # Use the default browser stack
    get "/", ExampleApp.PageController, :index
    post "/", ExampleApp.PageController, :index
    get "/required_login", ExampleApp.PageController, :required_login
    resources "/user_management", ExampleApp.UserManagementController, only: [:index, :delete]
  end


  # Other scopes may use custom stacks.
  # scope "/api", ExampleApp do
  #   pipe_through :api
  # end
end
