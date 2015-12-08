defmodule Addict.SessionInteractor do
  import Plug.Conn

  def register({:ok, user}, conn) do
    conn = fetch_session(conn)
    |> put_status(201)
    |> create_session(user)
    |> halt

    {conn, %{message: "user created", user: sanitize_user(user)}}
  end

  def register({:error, message}, conn) do
    conn = fetch_session(conn)
    |> put_status(400)
    {conn, %{message: message}}
  end

  def login({:ok, user}, conn)  do
    conn = fetch_session(conn)
    |> put_status(200)
    |> create_session(user)
    |> halt
    {conn, %{message: "logged in", user: sanitize_user(user)}}
  end

  def login({:error, _}, conn) do
    conn = conn
    |> put_status(400)
    {conn, %{message: "invalid email or password"}}
  end

  def logout(conn) do
    conn = fetch_session(conn)
    |> delete_session(:current_user)
    |> put_status(200)

    {conn, %{message: "logged out"}}
  end

  def password_recover({:ok, _}, conn) do
    conn = conn
    |> put_status(200)
    |> halt
    {conn, %{message: "email sent"}}
  end

  def password_recover({:error, message}, conn) do
    conn = conn
    |> put_status(400)
    {conn, %{message: message}}
  end

  def password_reset({:ok, _}, conn) do
    conn = conn
    |> put_status(200)
    |> halt
    {conn, %{message: "password reset"}}
  end

  def password_reset({:error, message}, conn) do
    conn = conn
    |> put_status(400)
    {conn, %{message: message}}
  end

  #
  # Private functions
  #

  defp create_session(conn, user) do
    conn
    |> put_session(:current_user, user)
  end

  defp sanitize_user(user) do
    user
    |> Map.drop [:hash, :recovery_hash, :__meta__, :__struct__]
  end

end
