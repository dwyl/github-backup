defmodule App.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Comment, Issue}


  schema "comments" do
    field :comment_id, :integer
    belongs_to :issue, Issue

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:comment_id])
    |> validate_required([:comment_id])
  end
end
