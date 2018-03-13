defmodule AppWeb.EventTypeHandlers do
  alias App.{Comment, Issue, Repo}
  alias Ecto.Changeset
  use AppWeb, :controller

  @github_api Application.get_env(:app, :github_api)
  @s3_api Application.get_env(:app, :s3_api)

  @moduledoc """
  Determines the type of event received by the Github Webhooks requests
  """

  def new_installation(conn, payload) do
    token = @github_api.get_installation_token(payload["installation"]["id"])
    repositories = payload["repositories"]

    repo_data = Enum.map(repositories, fn r ->
      issues = @github_api.get_issues(token, r["full_name"], 1, [])
      comments = @github_api.get_comments(token, r["full_name"], 1, [])
                 |> Enum.group_by(&(&1["issue_url"]))
      issues = Enum.map(issues, fn i ->
        Map.put(i, "comments", comments[i["url"]] || [])
      end)
      %{
        repository: r,
        issues: issues,
      }
    end)
    # create list of issue schema
    issues = Enum.flat_map(repo_data, fn r ->
      r.issues
      |> Enum.map(fn i ->
        %{
          pull_request: Map.has_key?(i, "pull_request"),
          issue_id: i["id"],
          title: i["title"],
          description: i["body"],
          issue_author: i["user"]["login"],
          comments: Enum.map(i["comments"], fn c ->
            %{
              comment_id: "#{c["id"]}",
              versions: [%{author: c["user"]["login"]}],
              comment: c["body"]
            }
          end)
        }
      end)
    end)

    # Add description issue has comment too!
    issues = Enum.map(issues, fn i ->
      comment_issue = %{
        comment_id: "#{i.issue_id}_1",
        versions: [%{author: i.issue_author}],
        comment: i.description
      }
      comments = [comment_issue | i.comments]
      Map.put(i, :comments, comments)
    end)

    # filter issue to remove PRs
    issues = Enum.filter(issues, fn i ->
      !i.pull_request
    end)

    # create map for comments
    comments_body = Enum.map(issues, fn i ->
      Enum.map(i.comments, fn c ->
        %{c.comment_id => c.comment}
      end)
    end)

    comments_body = comments_body
                    |> List.flatten()
                    |> Enum.reduce(%{}, fn(c, acc) ->
                      Map.merge(c, acc)
                    end)

    # save issue
    Enum.each(issues, fn i ->
      changeset = Issue.changeset(%Issue{}, i)
      issue = Repo.insert!(changeset)
      comments = issue.comments

      versions = Enum.map(comments, fn c ->
        v = c.versions
        |> List.first()

        %{v.id => comments_body[c.comment_id]}
      end)

      s3_data = Enum.reduce(versions, %{}, fn(v, acc) ->
        Map.merge(v, acc)
      end)

      content = Poison.encode!(s3_data)
      @s3_api.save_comment(issue.issue_id, content)
    end)

    conn
    |> put_status(200)
    |> json(%{ok: "new installation"})
  end

  def issue_created(conn, payload) do
    issue_params = %{
      issue_id: payload["issue"]["id"],
      title: payload["issue"]["title"],
      comments: [
        %{
          comment_id: "#{payload["issue"]["id"]}_1",
          versions: [%{author: payload["issue"]["user"]["login"]}]
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

    conn
    |> put_status(200)
    |> json(%{ok: "issue created"})
  end

  def issue_edited(conn, payload) do
      issue_id = payload["issue"]["id"]

      if Map.has_key?(payload["changes"], "title") do
          issue = Repo.get_by!(Issue, issue_id: issue_id)
          issue = Changeset.change issue, title: payload["issue"]["title"]
          Repo.update!(issue)
      end

      if Map.has_key?(payload["changes"], "title") do
        comment = payload["issue"]["body"]
        author = payload["sender"]["login"]
        add_comment_version(issue_id, "#{issue_id}_1", comment, author)
      end

      conn
      |> put_status(200)
      |> json(%{ok: "issue edited"})
  end

  def add_comment_version(issue_id, comment_id, content, author) do
    comment = Repo.get_by!(Comment, comment_id: "#{comment_id}")
    version_params = %{author: author}
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
    comment_params = %{
      comment_id: "#{payload["comment"]["id"]}",
      versions: [%{author: payload["comment"]["user"]["login"]}]
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
    author = payload["sender"]["login"]
    add_comment_version(issue_id, comment_id, comment, author)

    conn
    |> put_status(200)
    |> json(%{ok: "comment edited"})
  end

  def comment_deleted(conn, payload) do
    comment_id = payload["comment"]["id"]
    author = payload["sender"]["login"]
    comment = Repo.get_by!(Comment, comment_id: "#{comment_id}")
    changeset = Comment.changeset(comment)
    changeset = changeset
                |> Changeset.put_change(:deleted, true)
                |> Changeset.put_change(:deleted_by, author)
    Repo.update!(changeset)

    conn
    |> put_status(200)
    |> json(%{ok: "comment deleted"})
  end
end
