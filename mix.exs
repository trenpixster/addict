defmodule Addict.Mixfile do
  use Mix.Project

  def project do
    [app: :addict,
     version: "0.1.0",
     elixir: "~> 1.0",
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
    [:phoenix, :ecto, :comeonin, :mailgun, :logger]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:phoenix, ">= 0.15.0"},
     {:ecto, "~> 1.0"},
     {:comeonin, "~> 1.1" },
     {:mailgun, "~> 0.0.2"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7.1", only: :dev}]
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
