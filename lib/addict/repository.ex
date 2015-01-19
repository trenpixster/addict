defmodule Addict.Repository do
  require Logger

  import Ecto.Query
  @user Application.get_env(:addict, :user)

  def create(salt, hash, email, username) do
    try do
      new_user = db.insert(struct(@user,%{
        email: email,
        hash: hash,
        salt: salt,
        username: username,
        created_at: Ecto.DateTime.utc(),
        updated_at: Ecto.DateTime.utc()
      }))

      {:ok, new_user}
    rescue
      e in Postgrex.Error -> PostgresErrorHandler.handle_error(__MODULE__, e)
    end
  end

  def find_by_email(email) do
    try do
      query = from u in @user, where: u.email == ^email
      db.one query
    rescue
      e in Postgrex.Error -> PostgresErrorHandler.handle_error(__MODULE__, e)
    end
  end

  def db do
    IO.inspect Application.get_all_env(:addict)
    Application.get_env(:addict, :db)
  end

end
