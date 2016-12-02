# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :example_app,
  ecto_repos: [ExampleApp.Repo]

# Configures the endpoint
config :example_app, ExampleApp.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "yfHQS4p4x6/k7h8XJ4jNC5usq8xSkeJsgiRhv/PNVFW3M/ch2XDuN8U4y1eyGW0O",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: ExampleApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :addict,
  secret_key: "2432622431322479506177654c79303442354a5a4b784f592e444f332e",
  extra_validation: {ExampleApp.User, :validate}, # define extra validation here
  user_schema: ExampleApp.User,
  repo: ExampleApp.Repo,
  from_email: "no-reply@example.com", # CHANGE THIS
  mailgun_domain: "https://api.mailgun.net/v3/CHANGE-THIS",
  mailgun_key: "key-CHANGE-THIS",
  mail_service: :mailgun,
  post_register: {ExampleApp, :post_register_hook},
  post_login: {ExampleApp, :post_login_hook},
  post_logout: {ExampleApp, :post_logout_hook},
  post_reset_password: {ExampleApp, :post_reset_password_hook},
  post_recover_password: {ExampleApp, :post_recover_password_hook}
