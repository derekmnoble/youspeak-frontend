defmodule YouSpeak.Repo.Migrations.AddSlugs do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :slug, :string
    end

    create unique_index(:groups, [:slug])

    alter table(:meetings) do
      add :slug, :string
    end

    create unique_index(:meetings, [:slug])
  end
end
