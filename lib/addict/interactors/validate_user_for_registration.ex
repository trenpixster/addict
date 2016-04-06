defmodule Addict.PasswordUser do
  use Ecto.Schema

  schema "users" do
    field :password, :string
    field :email, :string
  end
end

defmodule Addict.Interactors.ValidateUserForRegistration do
  import Ecto.Changeset
  alias Addict.Interactors.ValidatePassword
  def call(user_params, configs \\ Addict.Configs) do
    struct(configs.user_schema)
    |> cast(user_params, ~w(email), ~w())
    |> validate_format(:email, ~r/.+@.+/)
    |> unique_constraint(:email)
    |> validate_password(user_params["password"], configs.password_strategies)
    |> format_response
  end

  defp format_response([]) do
    {:ok, []}
  end

  defp format_response(errors) do
    {:error, errors}
  end

  defp validate_password(changeset, password, password_strategies) do
    %Addict.PasswordUser{}
    |> Ecto.Changeset.cast(%{password: password}, ~w(password), [])
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
