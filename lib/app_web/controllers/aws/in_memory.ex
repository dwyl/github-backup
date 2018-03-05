defmodule AppWeb.AWS.InMemory do
  @moduledoc """
  mock of S3 api functions for tests
  """

  def save_comment(_issue_id, _comment) do
    %{ok: %{}}
  end

  def get_issue(_issue_id) do
    %{content: "issue content"}
  end

end
