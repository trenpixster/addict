defmodule Addict.Interactors.UpdateUserPassword do
  alias Addict.Interactors.GenerateEncryptedPassword
  def call(user, password, repo \\ Addict.Configs.repo) do
    user
    |> Ecto.Changeset.change(encrypted_password: GenerateEncryptedPassword.call(password))
    |> repo.update
  end

end
