defmodule Addict.RoutesHelper do
  defmacro __using__(_) do
    quote do
      import Addict.RoutesHelper
    end
  end

  defmacro addict(:routes, options \\ %{}) do
    routes = [
      {:register, [:get, :post]},
      {:login, [:get, :post]},
      {:recover_password, [:get, :post]},
      {:reset_password, [:get, :post]},
      {:logout, [:delete]}
    ]

    for {route, methods} <- routes do
      route_options = options_for_route(route, options[route])
      for method <- methods do
        quote do
          unquote(method)(
          unquote(route_options[:path]),
          unquote(route_options[:controller]),
          unquote(route_options[:action]),
          as: unquote(route_options[:as]))
        end
      end
    end
  end

  defp options_for_route(route, options) when is_list(options) do
    path       = route_path(route, options[:path])
    controller = options[:controller] || Addict.AddictController
    action     = options[:action] || route
    as         = route

    %{path: path, controller: controller, action: action, as: as}
  end

  defp options_for_route(route, path) do
    options_for_route(route, [path: route_path(route, path)])
  end

  defp route_path(route, path) do
    path || "/#{to_string(route)}"
  end
end
