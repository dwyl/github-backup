defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias Poison
  alias App.{Issue, Version, Repo}
  import Ecto.Query

  @s3_api Application.get_env(:app, :s3_api)

  def show(conn, params) do
    issue_id = params["id"]
    issue = Repo.get_by!(Issue, issue_id: issue_id)

    issue_data = issue
      |> Repo.preload([
        comments: [
          versions: {
             from(v in Version, order_by: [desc: v.inserted_at]),
            [:user]
          }
        ]
      ])
    comments_details = issue_data.comments

    {:ok, %{body: comments_text}} = @s3_api.get_issue(issue_id)
    comments_text = comments_text |> Poison.decode!

    render(
      conn,
      "index.html",
      issue_title: issue_data.title,
      comments_text: comments_text,
      comment_details: comments_details
    )
  end
end
