defmodule InjectHashTest do
  alias Addict.Interactors.InjectHash
  use ExUnit.Case, async: true

  test "it injects the encrypted_password attribute" do
    params = %{"email" => "john.doe@example.com", "password" => "ma pass phrase"}
    encrypted_password = InjectHash.call(params)["encrypted_password"]
    assert Comeonin.Pbkdf2.checkpw(params["password"], encrypted_password) == true
  end

  test "it injects the encrypted_password attribute with custom hasher" do
    Application.put_env(:addict, :password_hasher, TestDumbHasher)
    params = %{"email" => "steve@example.com", "password" => "g0g0h0lm3s"}
    encrypted_password = InjectHash.call(params)["encrypted_password"]
    assert encrypted_password == "dumb-g0g0h0lm3s-password"
  after
    Application.delete_env(:addict, :password_hasher)
  end

  test "it removes the password attribute" do
    params = %{"email" => "john.doe@example.com", "password" => "ma pass phrase"}
    new_params = InjectHash.call(params)
    assert new_params["password"] == nil
  end
end
