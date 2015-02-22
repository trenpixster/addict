defmodule Addict.RoutesHelper do
  defmacro __using__(_) do
    quote do
      import Addict.RoutesHelper
    end
  end

  defmacro addict(:routes, options \\ %{}) do
    quote do
      post unquote(options[:register]) || "/register", Addict.Controller, :register, as: :register
      post unquote(options[:login]) || "/login", Addict.Controller, :login, as: :login
      post unquote(options[:logout]) || "/logout", Addict.Controller, :logout, as: :logout
      post unquote(options[:recover_password]) || "/password_recover", Addict.Controller, :recover_password, as: :recover_password
      post unquote(options[:reset_password]) || "/password_reset", Addict.Controller, :reset_password, as: :reset_password
    end
  end
end
