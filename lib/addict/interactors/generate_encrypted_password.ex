defmodule Addict.Interactors.GenerateEncryptedPassword do
  @doc """
  Securely hashes `password`

  Returns the hash as a String
  """
  def call(password) do
    Comeonin.Pbkdf2.hashpwsalt password
  end
end
