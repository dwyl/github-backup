defmodule AppWeb.EditCountControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, Repo}

  describe "get svg count for an issue" do
    setup do
      issue_params = %{
        issue_id: 2,
        title: "Test issue title",
        comments: [
          %{
            comment_id: "2_1",
            versions: [%{author: "SimonLab"}]
          },
          %{
            comment_id: "1111",
            versions: [%{author: "SimonLab"}]
          }
        ]
      }

      changeset = Issue.changeset(%Issue{}, issue_params)
      issue = Repo.insert!(changeset)
      {:ok, conn: build_conn() |> assign(:issue, issue)}
    end

    test "GET /edit-count/2", %{conn: conn} do
      conn = get conn, "edit-count/2"
      assert response(conn, 200) =~ "Edit Count"
    end
  end
end
