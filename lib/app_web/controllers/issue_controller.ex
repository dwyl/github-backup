defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias AppWeb.AWS.S3
  alias Poison
  alias App.{Issue, Repo, Version}

  def show(conn, params) do
    {:ok, %{body: comments}} = S3.get_issue(params["id"])
    data =
      comments
      |> Poison.decode!
      |> Map.to_list

    issue =
      Repo.get_by!(Issue, issue_id: params["id"])
      |> Repo.preload([comments: [:versions]])

    comment_versions =
      issue.comments
      |> Enum.at(0)
      |> Map.get(:versions)
      |> Enum.map(fn version -> version.inserted_at end)
      |> Enum.map(fn version_inserted -> NaiveDateTime.truncate(version_inserted, :second) end)

    combined_data = List.zip([data, comment_versions]) |> Enum.reverse

    [latest_version | rest] = combined_data
    {{lv_id, lv_content}, lv_inserted} = latest_version

    render(conn, "index.html", latest_version_content: lv_content,
    latest_version_inserted: lv_inserted, latest_version_id: lv_id, rest: rest,
    issue_title: issue.title)
  end
end
