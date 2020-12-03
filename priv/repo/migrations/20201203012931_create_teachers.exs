defmodule YouSpeak.Repo.Migrations.CreateTeachers do
  use Ecto.Migration

  def change do
    create table(:teachers) do
      add :name, :string, null: false, limit: 200
      add :namespace, :string, null: false, limit: 200
      add :description, :text
      add :url, :string

      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:teachers, [:namespace])
  end
end
