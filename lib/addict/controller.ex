defmodule Addict.Controller do
  @moduledoc """
  The Addict Controller is used to receive User related requests directly from
  the Phoenix router.  Adds `register/2`, `logout/2` and `login/2` functions.
  """
  use Phoenix.Controller
  alias Addict.ManagerInteractor, as: AddictManager

  plug :action

  @doc """
  Entry point for registering new users.

  `params` needs to include email, password and username.
  Returns a JSON response in the format `{message: text}` with status `201` for
  successful creation, or `400` for when an error occurs.
  On success, it also logs the new user in.
  """
  def register(conn, user_params) do
    AddictManager.create(user_params)
    |> do_register(conn)
  end

  @doc """
  Entry point for logging out users.

  Since it only deletes session data, it should always return a JSON response
  in the format `{message: "logged out"}` with a `200` status code.
  """
  def logout(conn, _) do
    fetch_session(conn)
    |> delete_session(:current_user)
    |> put_status(200)
    |> json %{message: "logged out"}
  end

  @doc """
  Entry point for logging users in.

  Params needs to be populated with `email` and `password`. It returns `200`
  status code along with the JSON response `{message: "logged in"}` or `400`
  with `{message: "invalid email or password"}`

  """
  def login(conn, params) do
    email = params["email"]
    password = params["password"]

    AddictManager.verify_password(email, password)
    |> do_login(conn)
  end

  @doc """
  Entry point for asking for a new password.

  Params need to be populated with `email`
  """
  def recover_password(conn, params) do
    email = params["email"]

    AddictManager.recover_password(email)
    |> do_password_recover(conn)
  end


  @doc """
  Entry point for setting a user's password given the reset token.

  Params needed to be populated with `token`, `password` and `password_confirm`
  """
  def reset_password(conn, params) do
    token = params["token"]
    password = params["password"]
    password_confirm = params["password_confirm"]

    AddictManager.reset_password(token, password, password_confirm)
    |> do_password_reset(conn)
  end

  #
  # Private functions
  #

  defp do_register({:ok, user}, conn) do
    fetch_session(conn)
    |> put_status(201)
    |> add_session(user)
    |> json %{message: "user created"}
  end

  defp do_register({:error, message}, conn) do
    fetch_session(conn)
    |> put_status(400)
    |> json %{message: message}
  end

  defp do_login({:ok, user}, conn)  do
    fetch_session(conn)
    |> put_status(200)
    |> add_session(user)
    |> json %{message: "logged in"}
  end

  defp do_login({:error, _}, conn) do
    conn
    |> put_status(400)
    |> json %{message: "invalid email or password"}
  end

  defp do_password_recover({:ok, _}, conn) do
    conn
    |>put_status(200)
    |> json %{message: "email sent"}
  end

  defp do_password_recover({:error, message}, conn) do
    conn
    |> put_status(400)
    |> json %{message: message}
  end

  defp do_password_reset({:ok, _}, conn) do
    conn
    |>put_status(200)
    |> json %{message: "password reset"}
  end

  defp do_password_reset({:error, message}, conn) do
    conn
    |> put_status(400)
    |> json %{message: message}
  end

  defp add_session(conn, user) do
    conn
    |> put_session(:current_user, user)
  end

end
