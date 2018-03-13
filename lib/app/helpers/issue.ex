defmodule App.Helpers.IssueHelper do
  @moduledoc """
  Helpers function for issues
  """
  def get_issues(issues) do
    issues
    |> Enum.filter(fn issue ->
      !issue.pull_request
    end)
  end

  def get_map_comments(issues) do
    issues
    |> Enum.map(fn i ->
      Enum.map(i.comments, fn c ->
        %{c.comment_id => c.comment}
      end)
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn(c, acc) ->
      Map.merge(c, acc)
    end)
  end

  def attach_comments(issues, comments) do
    comments = Enum.group_by(comments, &(&1["issue_url"]))
    Enum.map(issues, fn i ->
      Map.put(i, "comments", comments[i["url"]] || [])
    end)
  end

  def issues_as_comments(issues) do
    issues
    |> Enum.map(fn i ->
      comment_issue = %{
        comment_id: "#{i.issue_id}_1",
        versions: [%{author: i.issue_author}],
        comment: i.description
      }
      comments = [comment_issue | i.comments]
      Map.put(i, :comments, comments)
    end)
  end

  def get_s3_content(issue, comments) do
    issue.comments
    |> Enum.map(fn c ->
      version = c.versions
                |> List.first()
      %{version.id => comments[c.comment_id]}
    end)
    |> Enum.reduce(%{}, fn(version, acc) ->
      Map.merge(version, acc)
    end)
  end

end
