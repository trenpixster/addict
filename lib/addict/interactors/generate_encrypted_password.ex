defmodule Addict.Interactors.GenerateEncryptedPassword do
  def call(password) do
    Comeonin.Pbkdf2.hashpwsalt password
  end
end
