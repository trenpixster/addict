defmodule ValidatePasswordTest do
  alias Addict.Interactors.ValidatePassword
  use ExUnit.Case, async: true

  defmodule Addict.PasswordUser do
    use Ecto.Schema

    schema "users" do
      field :password, :string
      field :email, :string
    end
  end

  test "it passes on happy path" do
    changeset = %Addict.PasswordUser{} |> Ecto.Changeset.cast(%{password: "one passphrase"}, ~w(password),[])
    {:ok, errors} = ValidatePassword.call(changeset, [])
    assert errors == []
  end

  test "it validates the default use case" do
    changeset = %Addict.PasswordUser{} |> Ecto.Changeset.cast(%{password: "123"}, ~w(password),[])
    {:error, errors} = ValidatePassword.call(changeset, [])
    assert errors == [password: "is too short"]
  end
end
