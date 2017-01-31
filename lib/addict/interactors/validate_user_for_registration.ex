defmodule Addict.PasswordUser do
  use Ecto.Schema

  schema "users" do
    field :password, :string
    field :email, :string
  end
end

defmodule Addict.Interactors.ValidateUserForRegistration do
@doc """
Validates if the user is valid for insertion.
Checks if `password` is valid and if `email` is well formatted and unique.

Returns `{:ok, []}` or `{:error, [errors]}`
"""
  import Ecto.Changeset
  alias Addict.Interactors.ValidatePassword

  def call(user_params, configs \\ Addict.Configs) do
    struct(configs.user_schema)
    |> cast(user_params, [:email])
    |> validate_required(:email)
    |> validate_format(:email, ~r/.+@.+/)
    |> unique_constraint(:email)
    |> validate_password(user_params["password"], configs.password_strategies)
    |> format_response
  end

  defp format_response([]) do
    {:ok, []}
  end

  defp format_response(errors) do
    errors = Enum.map errors, fn ({key, {value, _}}) -> {key, value} end
    {:error, errors}
  end

  defp validate_password(changeset, password, password_strategies) do
    %Addict.PasswordUser{}
    |> Ecto.Changeset.cast(%{password: password}, [:password])
    |> Ecto.Changeset.validate_required(:password)
    |> ValidatePassword.call(password_strategies)
    |> do_validate_password(changeset.errors)
  end

  defp do_validate_password({:ok, _}, existing_errors) do
    existing_errors
  end

  defp do_validate_password({:error, messages}, existing_errors) do
    Enum.concat messages, existing_errors
  end
end
