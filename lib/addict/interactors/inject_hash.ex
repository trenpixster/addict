defmodule Addict.Interactors.InjectHash do
  alias Addict.Interactors.GenerateEncryptedPassword

  def call(user_params) do
    user_params
    |> Map.put("encrypted_password", GenerateEncryptedPassword.call(user_params["password"]))
    |> Map.drop(["password"])
  end
end
