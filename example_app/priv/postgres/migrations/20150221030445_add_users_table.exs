defmodule ExampleApp.DB.Postgres.Migrations.AddUsersTable do
  use Ecto.Migration

  def up do
    execute("""
      CREATE TABLE users(
        id serial primary key,
        email varchar(200),
        username varchar(200),
        hash varchar(130),
        recovery_hash varchar(130),
        inserted_at timestamp,
        updated_at timestamp,
        CONSTRAINT u_email_constraint UNIQUE (email)
      )
    """)
  end

  def down do
    execute("DROP TABLE users")
  end
end
