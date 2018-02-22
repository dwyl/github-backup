defmodule AppWeb.GithubAPI.InMemory do
  @moduledoc """
  mock of github api functions for tests
  """
  alias Poison.Parser, as: PP

  def get_installation_token(_installation_id) do
    "token_installation_1234"
  end

  def get_issues(_token, _payload) do
    []
  end

  def get_comments(_token, _payload) do
    []
  end

end
