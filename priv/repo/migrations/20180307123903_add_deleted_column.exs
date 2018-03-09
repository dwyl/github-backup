defmodule App.Repo.Migrations.AddDeletedColumn do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :deleted, :boolean, default: false
      add :deleted_by, :string
    end
  end
end
