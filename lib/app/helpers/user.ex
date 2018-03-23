defmodule App.Helpers.UserHelper do
  @moduledoc """
  Helpers function for users
  """
  alias App.{Repo, User}

  def insert_or_update_user(%{user_id: user_id} = params) do
    user =
      case Repo.get_by(User, user_id: user_id) do
        nil -> %User{user_id: user_id}
        user -> user
      end
user = user
    |> User.changeset(params)
    |> Repo.insert_or_update!
  end
end
