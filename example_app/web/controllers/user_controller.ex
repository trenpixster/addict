defmodule ExampleApp.UserController do
  use ExampleApp.Web, :controller
  use Addict.BaseController

  def signout(conn,_) do
    {conn, message} = Addict.SessionInteractor.logout(conn)
    json conn, %{message: "Logged out! And this is a custom message"}
  end
end
