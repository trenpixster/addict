defmodule ValidateUserForRegistrationTest do
  alias Addict.Interactors.ValidateUserForRegistration
  use ExUnit.Case, async: false

  defmodule ConfigsMock do
    def password_strategies, do: []
    def user_schema, do: %TestAddictSchema{}
    def fn_extra_validation(arg), do: arg
  end

  test "it validates the default params" do
    user_params = %{
      "password" => "one passphrase",
      "email" => "bla@ble.com",
    }

    {status, errors} = ValidateUserForRegistration.call(user_params, ConfigsMock)

    assert errors == []
    assert status == :ok
  end

  test "it fails for invalid e-mail" do
    user_params = %{
      "password" => "one passphrase",
      "email" => "clearlyinvalid.com",
    }

    {status, errors} = ValidateUserForRegistration.call(user_params, ConfigsMock)

    assert errors == [email: "has invalid format"]
    assert status == :error
  end

  test "it fails for invalid e-mail and invalid password" do
    user_params = %{
      "password" => "123",
      "email" => "clearlyinvalid.com",
    }

    {status, errors} = ValidateUserForRegistration.call(user_params, ConfigsMock)
    assert errors == [password: "is too short", email: "has invalid format"]
    assert status == :error
  end

  test "it fails for missing fields" do
    user_params = %{}

    {status, errors} = ValidateUserForRegistration.call(user_params, ConfigsMock)

    assert errors == [password: "can't be blank", email: "can't be blank"]
    assert status == :error
  end

end
