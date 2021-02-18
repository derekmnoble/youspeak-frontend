defmodule YouSpeak.Repo.Migrations.AddSlugs do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :slug, :string
    end

    alter table(:meetings) do
      add :slug, :string
    end
  end
end
