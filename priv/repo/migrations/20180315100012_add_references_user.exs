defmodule App.Repo.Migrations.AddReferencesUser do
  use Ecto.Migration

  def change do
    alter table(:versions) do
      remove :author
      add :user_id, references :users
    end

    alter table(:comments) do
      modify :deleted_by, references(:users, column: :id, type: :integer)
    end

  end
end
