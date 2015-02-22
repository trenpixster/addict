# ExampleApp

This example app intends for you to better grok how to integrate Addict in your Phoenix App.

## Configuring

1 - Create a postgres db with the name "addict" and add a "addict" user with administration permissions on that database.  
2 - Run the script migration via `mix ecto.migrate -r ExampleApp.DB.Postgres`  
3 - Set the two required mailgun environment vars: `MAILGUN_DOMAIN` and `MAILGUN_KEY`  
4 - Run the phoenix app via `mix phoenix.server`  

## UI

When you fire up the browser to the running phoenix app you'll be able to test out all user management features that Addict supports.
I'm a master of UI/UX as you might've noticed `</irony>`.

## Important bits
Here are some important details that you might want to check out:

- [`configs.exs`](https://github.com/trenpixster/addict/blob/master/example_app/config/config.exs) - `config :addict` shows all required configurations.
- [`email_presenter.ex`](https://github.com/trenpixster/addict/blob/master/example_app/lib/presenters/email_presenter.ex) - required e-mail templates
- [`router.ex`](https://github.com/trenpixster/addict/blob/master/example_app/web/router.ex) - binding local endpoints to Addict Control(ler)
- [`page_controller.ex`](https://github.com/trenpixster/addict/blob/master/example_app/web/controllers/page_controller.ex) - Filtering a method for logged in users via `Addict.Plugs.Authenticated`
- [`user_controller.ex`](https://github.com/trenpixster/addict/blob/master/example_app/web/controllers/user_controller.ex) - Overriding an addict controller method
