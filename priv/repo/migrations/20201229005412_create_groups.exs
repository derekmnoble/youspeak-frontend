defmodule YouSpeak.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false, limit: 200
      add :description, :text
      add :activated_at, :timestamp
      add :inactivated_at, :timestamp

      add :teacher_id, references(:teachers)

      timestamps()
    end
  end
end
