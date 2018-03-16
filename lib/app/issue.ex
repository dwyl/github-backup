defmodule App.Issue do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Issue, Comment}

  @moduledoc """
  issue schema, define changeset to validate issue params
  """

  schema "issues" do
    field :issue_id, :integer
    field :title, :string
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(%Issue{} = issue, attrs \\ %{}) do
    issue
    |> cast(attrs, [:issue_id, :title, :inserted_at, :updated_at])
    |> cast_assoc(:comments, require: true)
    |> validate_required([:issue_id, :title])
  end
end
