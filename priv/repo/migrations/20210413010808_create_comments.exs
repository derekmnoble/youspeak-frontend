defmodule YouSpeak.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :url, :string, null: false

      add :meeting_id, references(:meetings)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
