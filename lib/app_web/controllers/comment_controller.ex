defmodule AppWeb.CommentController do
  use AppWeb, :controller
  alias Poison
  alias App.{Comment, Repo, Version}
  import Ecto.Query

  @s3_api Application.get_env(:app, :s3_api)

  def show(conn, params) do
    comment = Repo.get_by!(Comment, comment_id: params["id"])
    comment_details = comment
      |> Repo.preload([
          :issue,
          versions: from(v in Version, order_by: [desc: v.inserted_at])
        ])

    issue_id = comment_details.issue.issue_id

    {:ok, %{body: comments_text}} = @s3_api.get_issue(issue_id)

    comments_text =
      comments_text
      |> Poison.decode!

    render(
      conn,
      "index.html",
      comments_text: comments_text,
      comment_details: comment_details
    )

  end
end
