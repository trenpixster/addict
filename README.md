[![Build Status](https://travis-ci.org/trenpixster/addict.svg)](https://travis-ci.org/trenpixster/addict) [![Hex.pm](http://img.shields.io/hexpm/v/addict.svg)](https://hex.pm/packages/addict) [![Hex.pm](http://img.shields.io/hexpm/dt/addict.svg)](https://hex.pm/packages/addict)
[![Inline docs](http://inch-ci.org/github/trenpixster/addict.svg)](http://inch-ci.org/github/trenpixster/addict)

# Addict

Addict allows you to manage users authentication on your [Phoenix Framework](http://www.phoenixframework.org) app easily.

## What does it?
For now, it enables your users to register, login, logout and recover/reset their passwords.

## On what does it depend?
Addict depends on:
- [Phoenix Framework](http://www.phoenixframework.org)
- [Ecto](https://github.com/elixir-lang/ecto)

Optionally you can make Addict send e-mails for you too. At the moment only [Mailgun](https://mailgun.com) is supported.

## How can I get it started?

Addict is dependent on an ecto [User Model](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L18) and a [Database connection interface](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L12).

The user model must have at least the following schema:
```
  id serial primary key,
  email varchar(200),
  username varchar(200),
  hash varchar(130),
  recovery_hash varchar(130),
  CONSTRAINT u_constraint UNIQUE (email)
```

There are some application configurations you must add to your `configs.exs`:

```elixir
config :addict, not_logged_in_url: "/error",  # the URL where users will be redirected to
                db: MyApp.MyRepo,
                user: MyApp.MyUser,
                register_from_email: "Registration <welcome@yourawesomeapp.com>", # email registered users will receive from address
                register_subject: "Welcome to yourawesomeapp!", # email registered users will receive subject
                password_recover_from_email: "Password Recovery <no-reply@yourawesomeapp.com>",
                password_recover_subject: "You requested a password recovery link",
                email_templates: MyApp.MyEmailTemplates # email templates for sending e-mails, more on this further down

```

Environment specific configuration options go into their respective `config/*.exs`.
```elixir
config :addict, mailgun_domain: "yourawesomeapp.com",
                mailgun_key: "apikey-secr3tzapik3y"
```

The `email_templates` configuration should point to a module with the following structure:
```elixir
defmodule MyApp.MyEmailTemplates do
  def register_template(user) do
    """
      <h1>This is the HTML the user will receive upon registering</h1>
      You can access the user attributes: #{user.email}
    """
  end

  def password_recovery_template(user) do
    """
      <h1>This is the HTML the user will receive upon requesting a new password</h1>
      You should provide a link to your app where the token will be processed:
      <a href="http://yourawesomeapp.com/recover_password?token=#{user.recovery_hash}">like this</a>
    """
  end
end
```

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
        register_path  POST  /register          Addict.Controller.register/2
           login_path  POST  /login             Addict.Controller.login/2
          logout_path  POST  /logout            Addict.Controller.logout/2
recover_password_path  POST  /recover_password  Addict.Controller.recover_password/2
  reset_password_path  POST  /reset_password    Addict.Controller.reset_password/2
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
        register_path  POST  /register          Addict.Controller.register/2
           login_path  POST  /login             Addict.Controller.login/2
          logout_path  POST  /sign-out          ExampleApp.UserController.sign_out/2
recover_password_path  POST  /password/recover  Addict.Controller.recover_password/2
  reset_password_path  POST  /password/reset    Addict.Controller.reset_password/2
```

### Login/Register
**Please note:** The routes are all POST routes, meaning you need to create your own form (or similar) for registering and login in.

`AddictController.login/2` and `AddictController.register/2` both render a JSON upon success.
In the following example Rails's `jquery-ujs` was used to add functionality for sending forms asynchronously.

To install `jquery-ujs` add it to the dependencies in your `bower.json`. If that file does not exist, create it:

```JSON
{
  "name": "myawesomeapp",
  "dependencies": {
    "jquery-ujs": "~1.0.3",
  }
}
```

#### Example Forms
**Please note:** Currently the addict controller expects the params non-nested (i.e. `params[user_param]`, not `params[user][user_param]`).

```HTML
<h1>Login</h1>

<%= form_tag login_path(@conn, :login), method: :post, "data-remote": true,
      id: "login", do: fn -> %>
  <div class="form-group">
    <label>E-Mail</label>
    <input type="email" name="email" class="form-control"/>
  </div>

  <div class="form-group">
    <label>Password</label>
    <input type="password" name="password" class="form-control"/>
  </div>

  <div class="form-group">
    <%= submit "Login", class: "btn btn-primary" %>
  </div>
<% end %>
```

##### Handling the response with Javascript
Since we added the 'data-remote' attribute from `jquery-ujs` to the form we don't see anything
when we submit the form. It is sent asyncrhonously and we need to handle the response with Javascript,
for example with the following snippet in your `web/static/app.js`.

```Javascript
$("form#login").on("ajax:success", function(){
  window.location = "/" // redirect wherever you want to after login
}).on("ajax:error", function(){
  $(".alert-danger").html("Unable to login.");
});
```

If this does not work, make sure you have `<script src="<%= static_path(@conn, "/js/app.js") %>"></script>` at the end of your HTML body in your layout (e.g. `web/templates/layouts/application.html.eex`) or surround the code with jQuery's document ready handler.

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

If the user is not logged in and requests for the above action, he will be redirected to `not_logged_in_url`.

## Extending

If you need to extend controller of manager behaviour you can do it. You just have to create new modules and `use` Base modules:

```elixir
    defmodule ExtendedManagerInteractor do
      use Addict.BaseManagerInteractor

      defp validate_params(user_params) do
      ...
      end

    end
```


## TODO
Check the [issues](https://github.com/trenpixster/addict/issues) on this repository to check or track the ongoing improvements and new features.

## Contributing

Feel free to send your PR with improvements or corrections!

Special thanks to the folks at #elixir-lang on freenet for being so helpful every damn time!
