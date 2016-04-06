defmodule RegisterTest do
  # alias Addict.Interactors.ValidatePassword
  use ExUnit.Case, async: true

  test "it passes on happy path" do
    # changeset = %TestAddictUser{} |> Ecto.Changeset.cast(%{password: "one passphrase"}, ~w(password),[])
    # %Ecto.Changeset{errors: errors, valid?: valid} = ValidatePassword.call(changeset, [])
    # assert errors == []
    # assert valid == true
  end

  test "it validates the default use case" do
    # changeset = %TestAddictUser{} |> Ecto.Changeset.cast(%{password: "123"}, ~w(password),[])
    # %Ecto.Changeset{errors: errors, valid?: valid} = ValidatePassword.call(changeset, [])
    # assert errors == [password: "is too short"]
    # assert valid == false
  end
end
