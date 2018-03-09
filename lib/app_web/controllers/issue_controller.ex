defmodule AppWeb.IssueController do
  use AppWeb, :controller

  def show(conn, _params) do
    render(conn, "index.html")
  end
end
