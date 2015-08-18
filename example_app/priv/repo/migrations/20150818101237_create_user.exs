defmodule ExampleApp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email,         :string, size: 200
      add :username,      :string, size: 200
      add :hash,          :string, size: 130
      add :recovery_hash, :string, size: 130

      add :timestamps, :string

      timestamps
    end

  end
end
