defmodule AppWeb.CommentController do
  use AppWeb, :controller
  alias AppWeb.AWS.S3
  alias Poison
  alias App.{Comment, Issue, Repo, Version}
  import Ecto.Query

  def show(conn, params) do
    # Using the params in the url (the comment ID) we want to get the comment data from the DB
    comment_details =
      Repo.get_by!(Comment, comment_id: params["id"])
      |> Repo.preload([:issue, versions: from(v in Version, order_by: [desc: v.inserted_at])])

    issue_id = comment_details.issue.issue_id

    # Get file from S3 using issue ID
    {:ok, %{body: comments_text}} = S3.get_issue(issue_id)

    comments_text =
      comments_text
      |> Poison.decode!

    IO.inspect(comments_text)

    render(conn, "index.html", comments_text: comments_text, comment_details: comment_details)

    # comment_versions =
    #   issue.comments
    #   |> Enum.at(0)
    #   |> Map.get(:versions)
    #   |> Enum.map(fn version -> version.inserted_at end)
    #   |> Enum.map(fn version_inserted -> NaiveDateTime.truncate(version_inserted, :second) end)
    #
    # combined_data = List.zip([data, comment_versions]) |> Enum.reverse
    #
    # [latest_version | rest] = combined_data
    # {{lv_id, lv_content}, lv_inserted} = latest_version
    #
    # render(conn, "index.html", latest_version_content: lv_content,
    # latest_version_inserted: lv_inserted, latest_version_id: lv_id, rest: rest,
    # issue_title: issue.title)
  end
end
