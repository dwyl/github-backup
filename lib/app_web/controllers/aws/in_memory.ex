defmodule AppWeb.AWS.InMemory do
  @moduledoc """
  mock of S3 api functions for tests
  """
  alias App.{Issue, Repo}

  def save_comment(_issue_id, _comment) do
    %{ok: %{}}
  end

  def get_issue(issue_id) do
    issue = Repo.get_by!(Issue, issue_id: issue_id)
    issue_details = issue
      |> Repo.preload([comments: [:versions]])

    versions = Enum.flat_map(issue_details.comments, fn c ->
                c.versions
              end)
    json = Enum.reduce(versions, %{}, fn(v, acc) ->
      Map.put(acc, "#{v.id}", "comment")
    end)

    {:ok, %{body: Poison.encode!(json)}}
  end

end
