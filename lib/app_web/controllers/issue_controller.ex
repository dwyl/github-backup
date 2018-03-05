defmodule AppWeb.IssueController do
  use AppWeb, :controller
  alias AppWeb.AWS.S3
  alias Poison
  alias App.{Issue, Repo}

  def show(conn, params) do
    IO.inspect params # {"id" => "1"}
    # get the file with is params["id"].json
    {:ok, %{body: comments}} = S3.get_issue(params["id"])
    data = Poison.decode!(comments)
    #  Get the data from the db
    IO.inspect String.to_integer(params["id"])
    issue = Repo.get_by!(Issue, issue_id: params["id"])
    # preload comments and versions
    IO.inspect issue
    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    render conn, "index.html", comments: data
  end
end
