defmodule PresenterTest do
  alias Addict.Presenter
  use ExUnit.Case, async: true

  test "it strips associations" do
    user = struct(
      TestAddictUserAssociationsSchema,
      %{
        name: "Joe Doe",
        email: "joe.doe@example.com",
        encrypted_password: "what a hash!"
      })

    model = Presenter.strip_all(user, TestAddictUserAssociationsSchema)

    assert Map.has_key?(model, :__struct__) == false
    assert Map.has_key?(model, :__meta__) == false
    assert Map.has_key?(model, :drugs) == false
  end
end

defmodule TestAddictDrugsSchema do
  use Ecto.Schema
  schema "drugs" do
    field :name, :string
  end
end

defmodule TestAddictUserAssociationsSchema do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    has_many :drugs, TestAddictDrugsSchema
  end
end
