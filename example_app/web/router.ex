defmodule ExampleApp.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html, json)
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/" do
    pipe_through :browser # Use the default browser stack

    get "/", ExampleApp.PageController, :index
    get "/show", ExampleApp.PageController, :show
    get "/forbidden", ExampleApp.PageController, :forbidden

    post "/register", Addict.Controller, :register
    post "/logout", Addict.Controller, :logout
    post "/login", Addict.Controller, :login
    post "/password_recover", Addict.Controller, :recover_password
    post "/password_reset", Addict.Controller, :reset_password
  end
end
