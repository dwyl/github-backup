defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :user_id, :integer
      add :avatar_url, :string
      add :html_url, :string
      timestamps()
    end

    create unique_index :users, :user_id
  end
end
