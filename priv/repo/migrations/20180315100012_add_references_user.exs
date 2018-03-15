defmodule App.Repo.Migrations.AddReferencesUser do
  use Ecto.Migration

  def change do
    alter table(:versions) do
      remove :author
      add :author, references(:users, column: :id)
    end

    alter table(:comments) do
      remove :deleted_by
      add :deleted_by, references(:users, column: :id)
    end

  end
end
