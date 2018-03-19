defmodule AppWeb.EditCountControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, User, Repo}

  describe "get svg count for an issue" do
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
        issue_id: 2,
        title: "Test issue title",
        comments: [
          %{
            comment_id: "2_1",
            versions: [%{author: user.id}]
          },
          %{
            comment_id: "1111",
            versions: [%{author: user.id}]
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
