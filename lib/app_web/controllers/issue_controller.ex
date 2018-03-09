defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias Poison
  alias App.{Comment, Repo, Version}
  import Ecto.Query

  @s3_api Application.get_env(:app, :s3_api)

  def show(conn, params) do
    issue_id = params["id"]


    # Get values from S3
    {:ok, %{body: comments_text}} = @s3_api.get_issue(issue_id)

    comments_text =
      comments_text
      |> Poison.decode!

    IO.inspect(comments_text)

    render(
      conn,
      "index.html"
      comments_text: comments_text,
    )

  end
end
