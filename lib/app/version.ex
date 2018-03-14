defmodule App.Version do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Comment, Version}

  @moduledoc """
  version schema, define changeset to validate version params
  """

  schema "versions" do
    field :author, :string
    belongs_to :comment, Comment

    timestamps()
  end

  @doc false
  def changeset(%Version{} = version, attrs) do
    version
    |> cast(attrs, [:author, :inserted_at, :updated_at])
    |> validate_required([:author])
  end
end
