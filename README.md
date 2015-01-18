Addict
======

## What is it?
Addict allows you to manage users on your Phoenix app easily.

## What does it?
For now, it allows to register, login and logout your users.

## On what does it depend?
Addict depends on:
- [Phoenix Framework](www.phoenixframework.org)
- [Ecto](https://github.com/elixir-lang/ecto)
- [Mailgun](https://mailgun.com) (Don't have an account? Register for free and get 10000 e-mails per month included)

## How can I get it started?

Addict is dependent on an ecto [User Model](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L18) and a [Database connection interface](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L12).

The user model must have at least the following schema:
```
  id serial primary key,
  email varchar(200),
  username varchar(200),
  salt varchar(29),
  hash varchar(31),
  created_at timestamp,
  updated_at timestamp,
  CONSTRAINT u_constraint UNIQUE (email)
```

There are some application configurations you must add to your `configs.ex`:

```
config :addict, not_logged_in_url: "/error",  # the URL where users will be redirected to
                db: MyApp.MyRepo,
                user: MyApp.MyUser,
                register_from_email: "Registration <welcome@yourawesomeapp.com>", # email registered users will receive from address
                register_subject: "Welcome to yourawesomeapp!", # email registered users will receive subject
                email_templates: MyApp.MyEmailTemplates, # email templates for sending e-mails, more on this further down
                mailgun_domain: "yourawesomeapp.com",
                mailgun_key: "apikey-secr3tzapik3y"
```

The `email_templates` configuration should point to a model with the following structure:
```
defmodule MyApp.MyEmailTemplates do
  def register_template(options) do
    """
      <h1>This is the HTML the user will receive upon registering</h1>
      You can access the user attributes: #{user.email}
    """
  end
end
```

## How can I use it?
Just add the following to your `router.ex`:
```
    post "/register", UserController, :register
    post "/logout", UserController, :logout
    post "/login", UserController, :login
```

And use `AddictAuthenticated` plug to validate requests on your controllers:
```
defmodule MyAwesomeApp.PageController do
  use Phoenix.Controller

  plug AddictAuthenticated when action in [:foobar]
  plug :action

  def foobar(conn, _params) do
    render conn, "index.html"
  end

end
```

If the user is not logged in and requests for the above action, it will be redirected to `not_logged_in_url`.


## TODO
[ ] Validate user model fields
[ ] Implement "Forgot password" flow
[ ] Invite users ability
[ ] ... whatever else it will definitely come up

## Contributing

Feel free to send your PR with improvements or corrections!

Special thanks to the folks at #elixir-lang on freenet for being so helpful every damn time!