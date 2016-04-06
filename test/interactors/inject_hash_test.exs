defmodule InjectHashTest do
  alias Addict.Interactors.InjectHash
  use ExUnit.Case, async: true

  test "it injects the encrypted_password attribute" do
    params = %{"email" => "john.doe@example.com", "password" => "ma pass phrase"}
    encrypted_password = InjectHash.call(params)["encrypted_password"]
    assert Comeonin.Pbkdf2.checkpw(params["password"], encrypted_password) == true
  end

  test "it removes the password attribute" do
    params = %{"email" => "john.doe@example.com", "password" => "ma pass phrase"}
    new_params = InjectHash.call(params)
    assert new_params["password"] == nil
  end
end
