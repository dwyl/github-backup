defmodule App.Repo.Migrations.AddPr do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :pull_request, :boolean, default: false
    end
  end
end
