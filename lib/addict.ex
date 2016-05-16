defmodule Addict do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    IO.puts "starting addict main application"

    children = [
      worker(Addict.AuthenticationProvider, []),
    ]

    opts = [strategy: :one_for_one, name: Addict.Supervisor]

    IO.puts "starting addict supervisor"

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  # def config_change(changed, _new, removed) do
  #   Addict.Endpoint.config_change(changed, removed)
  #   :ok
  # end
end
