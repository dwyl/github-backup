defmodule AppWeb.CommentControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, User, Repo}

  describe "loads comment page" do
    setup do
      user = %User{
                login: "user_login",
                user_id: 1,
                avatar_url: "/avatar.jpg",
                html_url: "/user/1"
              }
              |> User.changeset
              |> Repo.insert!

      issue_params = %{
        issue_id: 1,
        title: "Test issue title",
        comments: [
          %{
            comment_id: "1_1",
            versions: [%{author: user.id}]
          }
        ]
      }

      changeset = Issue.changeset(%Issue{}, issue_params)
      issue = Repo.insert!(changeset)
      {:ok, conn: build_conn() |> assign(:issue, issue)}
    end

    test "GET /comments/1_1", %{conn: conn} do
      conn = get conn, "comments/1_1"

      assert html_response(conn, 200) =~ "Test issue title"
    end
  end
end
