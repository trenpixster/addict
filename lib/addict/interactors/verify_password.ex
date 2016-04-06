defmodule Addict.Interactors.VerifyPassword do
  import Ecto.Query

  def call(user, password) do
    Comeonin.Pbkdf2.checkpw(password, user.encrypted_password) |> process_response
  end

  defp process_response(false) do
    {:error, [authentication: "Incorrect e-mail/password"]}
  end

  defp process_response(true) do
    {:ok}
  end


end
