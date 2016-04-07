defmodule ExampleApp.UserManagementController do
  use ExampleApp.Web, :controller
  alias ExampleApp.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def register(conn, _params) do
    render(conn, "register.html", csrf_token: csrf_token(conn))
  end

  def login(conn,_params) do
    render(conn, "login.html", csrf_token: csrf_token(conn))
  end

  def send_reset_password_link(conn,_params) do
    render(conn, "send_reset_password_link.html", csrf_token: csrf_token(conn))
  end

  def reset_password(conn,params) do
    token = params["token"]
    signature = params["signature"]
    render(conn, "reset_password.html", token: token, signature: signature, csrf_token: csrf_token(conn))
  end

  def csrf_token(conn) do
    # csrf_token = Plug.CSRFProtection.get_csrf_token
    # Plug.Conn.put_session(conn, :_csrf_token, csrf_token)
    # csrf_token
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_management_path(conn, :index))
  end

end
