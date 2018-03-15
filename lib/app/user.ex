defmodule App.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.{User, Comment, Version}

  @moduledoc """
  user schema, define changeset to validate issue params
  """

  schema "users" do
    field :login, :string
    field :user_id, :integer
    field :avatar_url, :string
    field :html_url, :string

    has_many :comments, Comment, foreign_key: :deleted_by
    has_many :versions, Version, foreign_key: :author

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [
      :user_id,
      :login,
      :avatar_url,
      :html_url,
      :inserted_at,
      :updated_at]
    )
    |> cast_assoc(:comments, require: true)
    |> validate_required([
      :user_id,
      :login,
      :avatar_url,
      :html_url,
    ])
  end
end