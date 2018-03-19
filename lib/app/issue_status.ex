defmodule App.IssueStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{Issue, IssueStatus}

  @moduledoc """
  issue status schema, define changeset to validate issue params
  """

  schema "issue_status" do
    field :event, :string
    belongs_to :issue, Issue

    timestamps()
  end

  @doc false
  def changeset(%IssueStatus{} = issue_status, attrs) do
    issue_status
    |> cast(attrs, [:event, :inserted_at])
    |> validate_required([:event])
  end
end
