defmodule App.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Comment, Issue, Version}

  @moduledoc """
  comment schema, define changeset to validate comment params
  """

  schema "comments" do
    field :comment_id, :string
    field :deleted, :boolean
    field :deleted_by, :string
    belongs_to :issue, Issue
    has_many :versions, Version

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:comment_id])
    |> cast_assoc(:versions, require: true)
    |> validate_required([:comment_id])
  end
end
