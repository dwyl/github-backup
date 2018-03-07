defmodule App.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment_id, :string
      add :issue_id, references(:issues)

      timestamps()
    end
  end
end
