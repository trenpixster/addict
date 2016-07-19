defmodule Addict.AddictController do
  @moduledoc """
  Controller for addict

  Responsible for handling requests for serving templates (GETs) and managing users (POSTs)
  """
  use Phoenix.Controller

  @doc """
  Registers a user. Invokes `Addict.Configs.post_register/3` afterwards.

  Requires to have at least `"email"` and "`password`" on `user_params`
  """
  def register(%{method: "POST"} = conn, user_params) do
    user_params = parse(user_params)
    result = with {:ok, user} <- Addict.Interactors.Register.call(user_params),
                  {:ok, conn} <- Addict.Interactors.CreateSession.call(conn, user),
              do: {:ok, conn, user}

    case result do
      {:ok, conn, user} -> return_success(conn, user, Addict.Configs.post_register, 201)
      {:error, errors} -> return_error(conn, errors, Addict.Configs.post_register)
    end
  end

  @doc """
  Renders registration layout
  """
  def register(%{method: "GET"} = conn, _) do
    csrf_token = generate_csrf_token
    conn
    |> put_addict_layout
    |> render("register.html", csrf_token: csrf_token)
  end

  @doc """
  Logs in a user. Invokes `Addict.Configs.post_login/3` afterwards.

  Requires to have at least `"email"` and "`password`" on `auth_params`
  """
  def login(%{method: "POST"} = conn, auth_params) do
    auth_params = parse(auth_params)
    result = with {:ok, user} <- Addict.Interactors.Login.call(auth_params),
                  {:ok, conn} <- Addict.Interactors.CreateSession.call(conn, user),
              do: {:ok, conn, user}

     case result do
       {:ok, conn, user} -> return_success(conn, user, Addict.Configs.post_login)
       {:error, errors} -> return_error(conn, errors, Addict.Configs.post_login)
     end
  end

  @doc """
  Renders login layout
  """
  def login(%{method: "GET"} = conn, _) do
    csrf_token = generate_csrf_token
    conn
    |> put_addict_layout
    |> render("login.html", csrf_token: csrf_token)
  end

  @doc """
  Logs out the user. Invokes `Addict.Configs.post_logout/3` afterwards.

  No required params, it removes the session of the logged in user.
  """
  def logout(%{method: "DELETE"} = conn, _) do
     case Addict.Interactors.DestroySession.call(conn) do
       {:ok, conn} -> return_success(conn, %{}, Addict.Configs.post_logout)
       {:error, errors} -> return_error(conn, errors, Addict.Configs.post_logout)
     end
  end

  @doc """
  Recover user password. Sends an e-mail with a reset password link. Invokes `Addict.Configs.post_recover_password/3` afterwards.

  Requires to have `"email"` on `user_params`
  """
  def recover_password(%{method: "POST"} = conn, user_params) do
    user_params = parse(user_params)
    email = user_params["email"]
    case Addict.Interactors.SendResetPasswordEmail.call(email) do
      {:ok, _} -> return_success(conn, %{}, Addict.Configs.post_recover_password)
      {:error, errors} -> return_error(conn, errors, Addict.Configs.post_recover_password)
    end
  end

  @doc """
  Renders Password Recovery layout
  """
  def recover_password(%{method: "GET"} = conn, _) do
    csrf_token = generate_csrf_token
    conn
    |> put_addict_layout
    |> render("recover_password.html", csrf_token: csrf_token)
  end

  @doc """
  Resets the user password. Invokes `Addict.Configs.post_reset_password/3` afterwards.

  Requires to have  `"token"`, `"signature"` and "`password`" on `params`
  """
  def reset_password(%{method: "POST"} = conn, params) do
    params = parse(params)
    case Addict.Interactors.ResetPassword.call(params) do
      {:ok, _} -> return_success(conn, %{}, Addict.Configs.post_reset_password)
      {:error, errors} -> return_error(conn, errors, Addict.Configs.post_reset_password)
    end
  end

  @doc """
  Renders Password Reset layout
  """
  def reset_password(%{method: "GET"} = conn, params) do
    csrf_token = generate_csrf_token
    token = params["token"]
    signature = params["signature"]
    conn
    |> put_addict_layout
    |> render("reset_password.html", token: token, signature: signature, csrf_token: csrf_token)
  end

  defp return_success(conn, user, custom_fn, status \\ 200) do
    if custom_fn == nil, do: custom_fn = fn(a,_,_) -> a end

    conn
    |> put_status(status)
    |> custom_fn.(:ok, user)
    |> json(Addict.Presenter.strip_all(user))
  end

  defp return_error(conn, errors, custom_fn) do
    if custom_fn == nil, do: custom_fn = fn (a,_,_) -> a end
    errors = errors |> Enum.map(fn {key, value} ->
      %{message: "#{Macro.camelize(Atom.to_string(key))}: #{value}"}
    end)
    conn
    |> custom_fn.(:error, errors)
    |> put_status(400)
    |> json(%{errors: errors})
  end

  defp put_addict_layout(conn) do
    conn
    |> put_layout({Addict.AddictView, "addict.html"})
  end

  defp generate_csrf_token do
    if Addict.Configs.generate_csrf_token != nil do
      Addict.Helper.exec Addict.Configs.generate_csrf_token, []
    else
      ""
    end
  end

  defp parse(user_params) do
    if user_params[schema_name_string] != nil do
      user_params[schema_name_string]
    else
      user_params
    end
  end

  defp schema_name_string do
    to_string(Addict.Configs.user_schema)
    |> String.split(".")
    |> Enum.at(-1)
    |> String.downcase
  end

end
