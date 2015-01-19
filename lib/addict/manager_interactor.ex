defmodule Addict.ManagerInteractor do
  require Logger

  def create(email, username, password, repo \\ Addict.Repository, mailer \\ Addict.EmailGateway) do
    generate_password(password)
    |> create_username(email, username, repo)
    |> send_welcome_email(mailer)
  end

  def verify_password(email, password, repo \\ Addict.Repository) do
    user = repo.find_by_email email

    if valid_credentials(user, password) do
      {:ok, user}
    else
      {:error, "incorrect user or password"}
    end
  end

  #
  # Private functions
  #
  defp create_username({hash, salt}, email, username, repo) do
    repo.create(salt, hash, email, username)
  end

  defp send_welcome_email({:ok, user}, mailer) do
    result = mailer.send_welcome_email(user)
    case result do
      {:ok, _} -> {:ok, user}
      {:error, message} -> {:error, message}
    end
  end

  defp send_welcome_email({:error, message}, _) do
    {:error, message}
  end

  defp valid_credentials(nil, _) do
    false
  end

  defp valid_credentials(user, password) do
    user.hash == generate_hash_from_salt(password, user.salt)
  end

  defp generate_hash_from_salt(password, salt) do
    {:ok, hash} = :bcrypt.hashpw(password, salt)
    hash |> to_string |> String.slice(29,61)
  end

  defp generate_password(password) do
    {:ok, salt} = :bcrypt.gen_salt()
    {:ok, hash} = :bcrypt.hashpw(password, salt)
    salt = salt |> to_string
    hash = hash |> to_string |> String.slice(29,61)
    {hash, salt}
  end

end
