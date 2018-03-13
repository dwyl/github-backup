defmodule AppWeb.GithubAPI.InMemory do
  @moduledoc """
  mock of github api functions for tests
  """

  def get_installation_token(_installation_id) do
    "token_installation_1234"
  end

  def get_issues(_token, _payload, _page, _issues) do
    []
  end

  def get_comments(_token, _repo, _page, _comments) do
    []
  end

end
