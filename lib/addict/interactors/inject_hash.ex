defmodule Addict.Interactors.InjectHash do
  alias Addict.Interactors.GenerateEncryptedPassword
  @doc """
  Adds `"encrypted_password"` and drops `"password"` from provided hash.

  Returns the new hash with `"encrypted_password"` and without `"password"`.
  """
  def call(user_params) do
    user_params
    |> Map.put("encrypted_password", GenerateEncryptedPassword.call(user_params["password"]))
    |> Map.drop(["password"])
  end
end
