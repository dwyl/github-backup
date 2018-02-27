defmodule AppWeb.PageController do
  use AppWeb, :controller
  alias AppWeb.AWS.S3


  def index(conn, _params) do
    S3.get_files_bucket()
    render conn, "index.html"
  end
end
