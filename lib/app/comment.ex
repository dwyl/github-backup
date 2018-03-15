defmodule App.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Comment, Issue, User, Version}

  @moduledoc """
  comment schema, define changeset to validate comment params
  """

  schema "comments" do
    field :comment_id, :string
    field :deleted, :boolean
    field :deleted_by, :integer
    belongs_to :issue, Issue
    belongs_to :user, User, foreign_key: :deleted_by
    has_many :versions, Version

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:comment_id, :inserted_at, :updated_at])
    |> cast_assoc(:versions, require: true)
    |> validate_required([:comment_id])
  end
end
