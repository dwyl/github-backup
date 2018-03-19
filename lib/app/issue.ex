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
    field :pull_request, :boolean
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  @required_attrs ~w(issue_id title)a
  @optional_attrs ~w(pull_request inserted_at updated_at)a
  def changeset(%Issue{} = issue, attrs \\ %{}) do
    issue
    |> cast(attrs, @optional_attrs ++ @required_attrs)
    |> cast_assoc(:comments, require: true)
    |> validate_required(@required_attrs)
  end
end
