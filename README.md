[![Build Status](https://travis-ci.org/trenpixster/addict.svg)](https://travis-ci.org/trenpixster/addict) [![Hex.pm](http://img.shields.io/hexpm/v/addict.svg)](https://hex.pm/packages/addict) [![Hex.pm](http://img.shields.io/hexpm/dt/addict.svg)](https://hex.pm/packages/addict)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/trenpixster/addict.svg)](https://beta.hexfaktor.org/github/trenpixster/addict)
[![Inline docs](http://inch-ci.org/github/trenpixster/addict.svg)](http://inch-ci.org/github/trenpixster/addict)

# Addict

Addict allows you to manage users registration and authentication on your [Phoenix Framework](http://www.phoenixframework.org) app easily.

## What does it do?
For now, it enables your users to register, login, logout and recover/reset their passwords.

## Requirements

Addict is dependent on an ecto [User Model](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L18) and a [Database connection interface](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L12).

The user model must have at least the following schema:
```elixir
  field :email, :string
  field :encrypted_password, :string
```

## Plug and go
1 - Add Addict to your dependencies:
```
 {:addict, "~> 0.2"}
```
2 - Generate Addict [configs](https://github.com/trenpixster/addict/blob/master/configs.md) via:
```
mix addict.generate.configs
```
3 - Generate ([opinionated](#gen_boilerplate)) boilerplate:
```
mix addict.generate.boilerplate
```
4 - Add Addict routes to your `router.ex`:
```elixir
defmodule YourApp.Router do
  (...)
  use Addict.RoutesHelper
  (...)
  scope "/" do
    addict :routes
  end
end
```
5 - Visit any of these paths on your app
```
/login
/register
/recover_password
/reset_password
```

## On what does it depend?
Addict depends on:
- [Phoenix Framework](http://www.phoenixframework.org)
- [Ecto](https://github.com/elixir-lang/ecto)

Optionally you can make Addict send e-mails for you too. At the moment only [Mailgun](https://mailgun.com) is supported. Feel free to contribute with [another service](#adding-custom-mailer)!

## Addict Configs

See all available configurations [here](https://github.com/trenpixster/addict/blob/master/configs.md).

## How can I use it?

### Routes

Add the following to your `router.ex`:

```elixir
defmodule ExampleApp.Router do
  use Phoenix.Router
  use Addict.RoutesHelper

  ...

  scope "/" do
    addict :routes
  end
end
```

This will generate the following routes:

```
        register_path  POST   / register          Addict.Controller.register/2
           login_path  POST   / login             Addict.Controller.login/2
          logout_path  DELETE / logout            Addict.Controller.logout/2
recover_password_path  POST   / recover_password  Addict.Controller.recover_password/2
  reset_password_path  POST   / reset_password    Addict.Controller.reset_password/2
```

You can also override the `path` or `controller`/`action` for a given route:

```elixir
addict :routes,
  logout: [path: "/sign-out", controller: ExampleApp.UserController, action: :sign_out],
  recover_password: "/password/recover",
  reset_password: "/password/reset"
```

These overrides will generate the following routes:

```
        register_path  POST   / register          Addict.Controller.register/2
           login_path  POST   / login             Addict.Controller.login/2
          logout_path  DELETE / sign-out          ExampleApp.UserController.sign_out/2
recover_password_path  POST   / password/recover  Addict.Controller.recover_password/2
  reset_password_path  POST   / password/reset    Addict.Controller.reset_password/2
```

### Interacting with Addict

After you've added the router and generated the configs, please take look at the optional boilerplate and the Example App. Here are the interesting bits:
- [Example AJAX interactions](https://github.com/trenpixster/addict/blob/master/boilerplate/addict.js)
- [AJAX Error Handling](https://github.com/trenpixster/addict/blob/master/boilerplate/addict.js#L67)
- [Restricted login path](https://github.com/trenpixster/addict/blob/master/example_app/web/controllers/page_controller.ex#L3)
- [Login Form](https://github.com/trenpixster/addict/blob/master/boilerplate/login.html.eex)

### Addict Helper

Addict saves information on the logged in user by setting `current_user` on the user's Session.
You might want to use the `Addict.Helper` module that encapsulates this logic:

- [`Addict.Helper.current_user/1`](https://hexdocs.pm/addict/Addict.Helper.html#current_user/1): Provided the `conn`, it returns the user model's hash representation, without any associations.
- [`Addict.Helper.is_logged_in/1`](https://hexdocs.pm/addict/Addict.Helper.html#is_logged_in/1): Provided the `conn`, it returns `true` if the user is logged in, `false` otherwise.

## Checking for authentication
Use `Addict.Plugs.Authenticated` plug to validate requests on your controllers:
```elixir
defmodule MyAwesomeApp.PageController do
  use Phoenix.Controller

  plug Addict.Plugs.Authenticated when action in [:foobar]
  plug :action

  def foobar(conn, _params) do
    render conn, "index.html"
  end

end
```

If the user is not logged in and requests for the above action, they will be redirected to `not_logged_in_url`.

## Adding Custom Mailer

For adding a custom Mailer just follow the conventions:
- Module must be `Addict.Mailers.TheEmailProvider`
- Add the Mailer file in `/lib/addict/mailers`
- Make sure the mailer implements the behaviour defined [here](https://github.com/trenpixster/addict/blob/master/lib/addict/mailers/generic.ex)

Once that is done, just set `mail_service` configuration to `:the_email_provider`.

## TODO
Check the [issues](https://github.com/trenpixster/addict/issues) on this repository to check or track the ongoing improvements and new features.

## Contributing

Feel free to send your PR with improvements or corrections!

Special thanks to the folks at #elixir-lang on freenet for being so helpful every damn time!
