defmodule TestAddictSchema do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
  end
end
