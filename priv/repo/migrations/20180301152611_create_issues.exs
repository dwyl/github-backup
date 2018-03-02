defmodule App.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :issue_id, :integer
      add :title, :string

      timestamps()
    end

  end
end
