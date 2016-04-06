defmodule Addict.Mixfile do
  use Mix.Project

  def project do
    [app: :addict,
     version: "0.1.0",
     elixir: "~> 1.2",
     description: description,
     package: package,
     docs: &docs/0,
     deps: deps]
  end

  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:test) do
    [:plug] ++ applications(:prod)
  end

  defp applications(_) do
    [:phoenix, :ecto, :comeonin, :mailgun, :logger, :crypto]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:phoenix, "~> 1.1"},
     {:ecto, "~> 1.1"},
     {:comeonin, "~> 2.1" },
     {:mailgun, "~> 0.1"},
     {:mock, "~> 0.1.3", only: :test},
     {:postgrex, ">= 0.0.0", only: :test},
     {:earmark, "~> 0.2", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
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
    Addict allows you to manage users on your Phoenix app easily. Register, login,
    logout, recover password and password updating is available off-the-shelf.
    """
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [source_ref: ref,
     main: "README",
     readme: "README.md"]
    end
end
