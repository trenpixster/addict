defmodule Addict.Interactors.Login do
  alias Addict.Interactors.{GetUserByEmail, VerifyPassword}

  @doc """
  Verifies if the `password` is correct for the provided `email`

  Returns `{:ok, user}` or `{:error, [errors]}`
  """
  def call(%{"email" => email, "password" => password}) do
    with {:ok, user} <- GetUserByEmail.call(email),
         {:ok} <- VerifyPassword.call(user, password),
     do: {:ok, user}
  end
end
