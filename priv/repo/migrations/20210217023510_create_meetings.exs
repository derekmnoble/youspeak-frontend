defmodule YouSpeak.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :name, :string, null: false, limit: 200
      add :description, :text
      add :video_url, :string, null: false

      add :group_id, references(:groups)

      timestamps()
    end
  end
end
