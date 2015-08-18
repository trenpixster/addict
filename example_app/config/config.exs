# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :example_app, ExampleApp.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "OKeKRkVu+SE7lfB6PaS0jk48GgrNEy5S/f8ezx35Uz1jjumn5s0HoCqYZfyc/xFy",
  render_errors: [default_format: "html"],
  pubsub: [name: ExampleApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict, user: ExampleApp.User,
                not_logged_in_url: "/forbidden",
                email_templates: ExampleApp.Presenters.EmailPresenter,
                db: ExampleApp.Repo,
                register_from_email: "ExampleApp <welcome@exampleapp.com>",
                register_subject: "Welcome to ExampleApp!",
                password_recover_from_email: "ExampleApp <no-reply@exampleapp.com>",
                password_recover_subject: "ExampleApp password recovery",
                mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
                mailgun_key: System.get_env("MAILGUN_KEY")