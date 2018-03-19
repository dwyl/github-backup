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

  @required_attrs ~w(user_id login avatar_url html_url)a
  @optional_attrs ~w(inserted_at updated_at)a
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @optional_attrs ++ @required_attrs)
    |> cast_assoc(:comments, require: true)
    |> validate_required(@required_attrs)
  end

end
