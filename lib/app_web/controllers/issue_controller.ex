defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias AppWeb.AWS.S3
  alias Poison
  alias App.{Issue, Repo}

  def show(conn, params) do
    {:ok, %{body: comments}} = S3.get_issue(params["id"])
    data = Poison.decode!(comments)
    issue = Repo.get_by!(Issue, issue_id: params["id"])
    # preload comments and versions
    render conn, "index.html", comments: data, issue_title: issue.title, comment_inserted: NaiveDateTime.truncate(issue.inserted_at, :second)
  end
end
