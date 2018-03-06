defmodule App.Repo.Migrations.CreateVersion do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :author, :string
      add :comment_id, references(:comments)

      timestamps()
    end
  end
end
