defmodule Addict.Mixfile do
  use Mix.Project

  def project do
    [app: :addict,
     version: "0.0.3",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps(Mix.env)]
  end

  def application do
    [applications: [:logger, :bcrypt]]
  end

  defp deps(:test) do
    [{:cowboy, "~> 1.0"}, {:mock, "~> 0.1.0"}] ++ deps(:prod)
  end

  defp deps(:prod) do
    [{:phoenix, "~> 0.8.0"},
     {:ecto, "~> 0.6.0"},
     {:bcrypt, github: "opscode/erlang-bcrypt"},
     {:mailgun, "~> 0.0.2"}]
  end

  defp deps(_) do
    deps(:prod)
  end

  defp package do
    [
         files: ["lib", "mix.exs", "README*", "LICENSE*"],
         contributors: ["Nizar Venturini"],
         licenses: ["MIT"],
         links: %{"GitHub" => "https://github.com/trenpixster/addict"}
    ]
  end

  defp description do
    """
    Addict allows you to manage users on your Phoenix app easily. Register, login and logout is available off-the-shelf.
    """
  end

end
