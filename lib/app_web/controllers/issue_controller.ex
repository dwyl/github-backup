defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias Poison
  alias App.{Issue, Version, Repo, IssueStatus}
  import Ecto.Query

  @s3_api Application.get_env(:app, :s3_api)

  def show(conn, params) do
    issue_id = params["id"]
    issue = Repo.get_by!(Issue, issue_id: issue_id)

    issue_data = issue
      |> Repo.preload([
        issue_status: from(s in IssueStatus, order_by: [desc: s.inserted_at]),
        comments: [
          versions: from(v in Version, order_by: [desc: v.inserted_at])
        ]
      ])

    comments_details = issue_data.comments
    issue_status = Enum.at(issue_data.issue_status, 0)

    issue_status_event = case Enum.at(issue_data.issue_status, 0) do
      nil ->
        "issue open"
      issue_status ->
        case issue_status.event do
          "closed" ->
            issue_status.event
          "reopened" ->
            issue_status.event
        end
    end

    {:ok, %{body: comments_text}} = @s3_api.get_issue(issue_id)
    comments_text = comments_text |> Poison.decode!

    render(
      conn,
      "index.html",
      issue_title: issue_data.title,
      issue_status: issue_status_event,
      comments_text: comments_text,
      comment_details: comments_details
    )
  end
end
