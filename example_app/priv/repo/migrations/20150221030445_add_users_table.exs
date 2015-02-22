defmodule Coffee.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email,         :string, size: 200
      add :username,      :string, size: 200
      add :hash,          :string, size: 130
      add :recovery_hash, :string, size: 130

      timestamps
    end

    create index(:users, [:email], unique: true)
  end

  def down do
    drop table(:users)
  end
end
