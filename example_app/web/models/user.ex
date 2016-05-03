defmodule ExampleApp.User do
  use ExampleApp.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string

    timestamps
  end

  @required_fields ~w(name email encrypted_password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def validate({valid, errors}, user_params) do
    {valid, errors}
  end
end
