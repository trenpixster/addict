defmodule Addict.Controller do
  use Phoenix.Controller
  alias AddictManagerInteractor, as: AddictManager

  plug :action

  def register(conn, params) do
    email = params["email"]
    password = params["password"]
    username = params["username"]

    AddictManager.create(email, username, password)
    |> do_register(conn)
  end

  def logout(conn, _) do
    fetch_session(conn)
    |> delete_session(:logged_in)
    |> delete_session(:current_user)
    |> put_status(200)
    |> json %{message: "logged out"}
  end

  def login(conn, params) do
    email = params["email"]
    password = params["password"]

    AddictManager.verify_password(email, password)
    |> do_login(conn)
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

  defp add_session(conn, user) do
    conn
    |> put_session(:logged_in, true)
    |> put_session(:current_user, user)
  end

end
