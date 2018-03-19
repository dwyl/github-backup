defmodule AppWeb.EventTypeHandlers do
  use AppWeb, :controller
  alias App.{Comment, Issue, Repo, User}
  alias App.Helpers.{IssueHelper, UserHelper}
  alias Ecto.Changeset
  alias AppWeb.MetaTable

  @github_api Application.get_env(:app, :github_api)
  @github_app_name Application.get_env(:app, :github_app_name)
  @s3_api Application.get_env(:app, :s3_api)

  @moduledoc """
  Determines the type of event received by the Github Webhooks requests
  """

  def unknow_event(conn) do
    conn
    |> put_status(404)
    |> json(%{ok: "event unkown"})
  end

  def new_installation(conn, payload) do
    token = @github_api.get_installation_token(payload["installation"]["id"])
    repositories = payload["repositories"]

    repo_data = Enum.map(repositories, fn r ->
      issues = @github_api.get_issues(token, r["full_name"], 1, [])
      comments = @github_api.get_comments(token, r["full_name"], 1, [])
      issues = IssueHelper.attach_comments(issues, comments)
      %{
        repository: r,
        issues: issues,
      }
    end)

    # create list of issue schema
    issues = Enum.flat_map(repo_data, fn r ->
      r.issues
      |> Enum.map(fn i ->
        author_params = %{
          login: i["user"]["login"],
          user_id: i["user"]["id"],
          avatar_url: i["user"]["avatar_url"],
          html_url: i["user"]["html_url"],
        }
        author_issue = UserHelper.insert_or_update_user(author_params)

        %{
          pull_request: Map.has_key?(i, "pull_request"),
          issue_id: i["id"],
          title: i["title"],
          description: i["body"],
          issue_author: author_issue,
          inserted_at: NaiveDateTime.from_iso8601!(i["created_at"]),
          updated_at: NaiveDateTime.from_iso8601!(i["created_at"]),
          comments: Enum.map(i["comments"], fn c ->
            author_params = %{
              login: c["user"]["login"],
              user_id: c["user"]["id"],
              avatar_url: c["user"]["avatar_url"],
              html_url: c["user"]["html_url"],
            }
            author_comment = UserHelper.insert_or_update_user(author_params)

            %{
              comment_id: "#{c["id"]}",
              versions: [%{
                author: author_comment.id,
                inserted_at: NaiveDateTime.from_iso8601!(c["created_at"]),
                updated_at: NaiveDateTime.from_iso8601!(c["created_at"])
              }],
              comment: c["body"],
              inserted_at: NaiveDateTime.from_iso8601!(c["created_at"]),
              updated_at: NaiveDateTime.from_iso8601!(c["created_at"])
            }
          end)
        }
      end)
    end)

    # Add description issue has comment too!
    issues = IssueHelper.issues_as_comments(issues)

    # filter issue to remove PRs
    issues = IssueHelper.get_issues(issues)

    # create map for comments: %{comment_id => comment_text, ...}
    comments_body = IssueHelper.get_map_comments(issues)

    # save issue
    Enum.each(issues, fn i ->
      changeset = Issue.changeset(%Issue{}, i)
      issue = Repo.insert!(changeset)

      s3_data = IssueHelper.get_s3_content(issue, comments_body)
      content = Poison.encode!(s3_data)
      @s3_api.save_comment(issue.issue_id, content)
    end)

    conn
    |> put_status(200)
    |> json(%{ok: "new installation"})
  end

  def issue_created(conn, payload) do
    token = @github_api.get_installation_token(payload["installation"]["id"])

    issue = if payload["pull_request"] != nil do
      repo_name = payload["repository"]["full_name"]
      issue_number = payload["pull_request"]["number"]
      @github_api.get_issue(token, repo_name, issue_number)
    else
      payload["issue"]
    end

    payload = Map.put(payload, "issue", issue)

    author_params = %{
      login: payload["issue"]["user"]["login"],
      user_id: payload["issue"]["user"]["id"],
      avatar_url: payload["issue"]["user"]["avatar_url"],
      html_url: payload["issue"]["user"]["html_url"]
    }
    author = UserHelper.insert_or_update_user(author_params)

    issue_params = %{
      issue_id: payload["issue"]["id"],
      title: payload["issue"]["title"],
      pull_request: Map.has_key?(payload, "pull_request"),
      comments: [
        %{
          comment_id: "#{payload["issue"]["id"]}_1",
          versions: [%{author: author.id}]
        }
      ]
    }

    changeset = Issue.changeset(%Issue{}, issue_params)
    issue = Repo.insert!(changeset)

    comment = payload["issue"]["body"]
    version_id = issue.comments
                 |> List.first()
                 |> Map.get(:versions)
                 |> List.first()
                 |> Map.get(:id)
    content = Poison.encode!(%{version_id => comment})
    @s3_api.save_comment(issue.issue_id, content)

    meta_table = MetaTable.get_meta_table(payload["issue"]["id"])
    content = comment <> "\r\n\n" <> meta_table

    repo_name = payload["repository"]["full_name"]
    issue_number = payload["issue"]["number"]
    @github_api.add_meta_table(repo_name, issue_number, content, token)

    conn
    |> put_status(200)
    |> json(%{ok: "issue created"})
  end

  def issue_edited(conn, payload) do
    token = @github_api.get_installation_token(payload["installation"]["id"])

    issue = if payload["pull_request"] != nil do
      repo_name = payload["repository"]["full_name"]
      issue_number = payload["pull_request"]["number"]
      @github_api.get_issue(token, repo_name, issue_number)
    else
      payload["issue"]
    end

    payload = Map.put(payload, "issue", issue)

    issue_id = payload["issue"]["id"]

    if Map.has_key?(payload["changes"], "title") do
        issue = Repo.get_by!(Issue, issue_id: issue_id)
        issue = Changeset.change issue, title: payload["issue"]["title"]
        Repo.update!(issue)
    end

    body_change = Map.has_key?(payload["changes"], "body")
    not_bot = payload["sender"]["login"] != @github_app_name <> "[bot]"
    if body_change && not_bot do
      comment = payload["issue"]["body"]
      author_params = %{
        login: payload["sender"]["login"],
        user_id: payload["sender"]["id"],
        avatar_url: payload["sender"]["avatar_url"],
        html_url: payload["sender"]["html_url"],
      }
      author = UserHelper.insert_or_update_user(author_params)
      add_comment_version(issue_id, "#{issue_id}_1", comment, author)
    end

    conn
    |> put_status(200)
    |> json(%{ok: "issue edited"})
  end

  def add_comment_version(issue_id, comment_id, content, author) do
    comment = Repo.get_by!(Comment, comment_id: "#{comment_id}")
    version_params = %{author: author.id}
    changeset = Ecto.build_assoc(comment, :versions, version_params)
    version = Repo.insert!(changeset)
    update_s3_file(issue_id, version.id, content)
  end

  def update_s3_file(issue_id, version_id, comment) do
    {:ok, s3_issue} = @s3_api.get_issue(issue_id)
    content = Poison.decode!(s3_issue.body)
    content = Map.put(content, version_id, comment)
    @s3_api.save_comment(issue_id, Poison.encode!(content))
  end

  def comment_created(conn, payload) do
    issue_id = payload["issue"]["id"]
    issue = Repo.get_by!(Issue, issue_id: issue_id)
    author_params = %{
      login: payload["comment"]["user"]["login"],
      user_id: payload["comment"]["user"]["id"],
      avatar_url: payload["comment"]["user"]["avatar_url"],
      html_url: payload["comment"]["user"]["html_url"],
    }
    author = UserHelper.insert_or_update_user(author_params)
    comment_params = %{
      comment_id: "#{payload["comment"]["id"]}",
      versions: [%{author: author.id}]
    }
    changeset = Ecto.build_assoc(issue, :comments, comment_params)
    comment = Repo.insert!(changeset)

    version = List.first(comment.versions)
    update_s3_file(issue_id, version.id, payload["comment"]["body"])

    conn
    |> put_status(200)
    |> json(%{ok: "comment created"})
  end

  def comment_edited(conn, payload) do
    issue_id = payload["issue"]["id"]
    comment_id = payload["comment"]["id"]
    comment = payload["comment"]["body"]
    author_params = %{
      login: payload["sender"]["login"],
      user_id: payload["sender"]["id"],
      avatar_url: payload["sender"]["avatar_url"],
      html_url: payload["sender"]["html_url"],
    }
    author = UserHelper.insert_or_update_user(author_params)
    add_comment_version(issue_id, comment_id, comment, author)

    conn
    |> put_status(200)
    |> json(%{ok: "comment edited"})
  end

  def comment_deleted(conn, payload) do
    comment_id = payload["comment"]["id"]
    author_params = %{
      login: payload["sender"]["login"],
      user_id: payload["sender"]["id"],
      avatar_url: payload["sender"]["avatar_url"],
      html_url: payload["sender"]["html_url"],
    }
    author = UserHelper.insert_or_update_user(author_params)
    comment = Repo.get_by!(Comment, comment_id: "#{comment_id}")
    changeset = Comment.changeset(comment)
    changeset = changeset
                |> Changeset.put_change(:deleted, true)
                |> Changeset.put_change(:deleted_by, author.id)
    Repo.update!(changeset)

    conn
    |> put_status(200)
    |> json(%{ok: "comment deleted"})
  end

end
