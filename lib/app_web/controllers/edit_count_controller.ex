defmodule AppWeb.EditCountController do
  use AppWeb, :controller
  alias App.{Issue, Repo}

  def show(conn, payload) do
    issue_id = payload["issue_id"]

    issue  = Repo.get_by!(Issue, issue_id: issue_id)
    issue = issue
            |> Repo.preload([
                comments: [:versions]
              ])

    comment_versions = Enum.map(issue.comments, fn c ->
      length(c.versions)
    end)

    count = Enum.sum(comment_versions) - length(issue.comments)

    svg = File.read!("./assets/static/images/edit_count.svg")
    svg = String.replace(svg, ~r/{count}/, to_string(count))
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, svg)
  end
end
