defmodule App.Repo.Migrations.AddConstraints do
  use Ecto.Migration

  def change do
    create unique_index :issues, :issue_id
    create unique_index :comments, :comment_id
  end
end
