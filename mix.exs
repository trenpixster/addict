defmodule Addict.Mixfile do
  use Mix.Project

  def project do
    [app: :addict,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:phoenix, :cowboy, :logger, :ecto, :bcrypt]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:phoenix, "~> 0.8.0"},
     {:cowboy, "~> 1.0"},
     {:postgrex, ">= 0.6.0"},
     {:ecto, "~> 0.2.6"},
     {:bcrypt, github: "opscode/erlang-bcrypt"},
     {:mailgun, "~> 0.0.2"}]
  end
end
