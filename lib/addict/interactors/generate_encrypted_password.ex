defmodule Addict.Interactors.GenerateEncryptedPassword do
  @doc """
  Securely hashes `password`

  Returns the hash as a String
  """
  def call(password) do
    Addict.Configs.password_hasher.hashpwsalt password
  end
end
