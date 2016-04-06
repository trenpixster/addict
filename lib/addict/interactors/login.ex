defmodule Addict.Interactors.Login do
  alias Addict.Interactors.{GetUserByEmail, VerifyPassword}

  def call(%{"email" => email, "password" => password}) do
    with {:ok, user} <- GetUserByEmail.call(email),
         {:ok} <- VerifyPassword.call(user, password),
     do: {:ok, user}
  end
end
