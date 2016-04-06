defmodule TestAddictMigrations do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :encrypted_password, :string
    end
  end
end
