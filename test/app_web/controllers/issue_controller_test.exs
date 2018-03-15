defmodule AppWeb.IssueControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, User, Repo}

  describe "loads issue page" do
    setup do
      user = %{
        login: "user_login",
        user_id: 1,
        avatar_url: "/avatar.jpg",
        html_url: "/user/1"
      }
      user_changeset = User.changeset(%User{}, user)
      user = Repo.insert!(user_changeset)

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

    test "GET /issues/1", %{conn: conn} do
      conn = get conn, "/issues/1"
      assert html_response(conn, 200) =~ "Test issue title"
    end
  end
end
