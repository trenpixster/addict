defmodule ExampleApp.Mixfile do
  use Mix.Project

  def project do
    [app: :example_app,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ExampleApp, []},
     applications: [:phoenix, :cowboy, :logger, :ecto]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.9.0"},
     {:cowboy, "~> 1.0"},
     {:postgrex, ">= 0.7.0"},
     {:ecto, ">= 0.8.0"},
     {:addict, github: "trenpixster/addict"}]
  end
end
