defmodule YouSpeak.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :role, :string, null: false, default: "teacher"
      add :provider, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
