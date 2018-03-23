defmodule App.Repo.Migrations.IssueStatus do
  use Ecto.Migration

  def change do
    create table(:issue_status) do
      add :event, :string
      add :issue_id, references(:issues)

      timestamps()
    end
  end
end
