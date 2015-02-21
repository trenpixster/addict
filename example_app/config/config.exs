# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :example_app, ExampleApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FvzfCCxDBNcqvE8KTOkxgyI0swSTqR8gr/JzVG0pir1fjMLdCqUUyr9F2HP2uMlb",
  debug_errors: false,
  pubsub: [adapter: Phoenix.PubSub.PG2]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :example_app, ExampleApp.DB.Postgres,
    url: "ecto://addict:@localhost/addict"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict, user: ExampleApp.Models.User,
                not_logged_in_url: "/forbidden",
                email_templates: ExampleApp.Presenters.EmailPresenter,
                db: ExampleApp.DB.Postgres,
                register_from_email: "ExampleApp <welcome@exampleapp.com>",
                register_subject: "Welcome to ExampleApp!",
                password_recover_from_email: "ExampleApp <no-reply@exampleapp.com>",
                password_recover_subject: "ExampleApp password recovery",
                mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
                mailgun_key: System.get_env("MAILGUN_KEY")
