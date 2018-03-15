defmodule App.Helpers.UserHelper do
  @moduledoc """
  Helpers function for users
  """
  alias App.{Repo, User}

  def udpate_or_update_user(params) do
    user = Repo.get_by(User, user_id: params.user_id)
    if user do
      changeset = User.changeset(user, params)
      Repo.update!(changeset)
    else
      changeset = User.changeset(%User{}, params)
      Repo.insert!(changeset)
    end
  end
end
