defmodule AppWeb.GithubAPI.InMemory do
  @moduledoc """
  mock of github api functions for tests
  """
  @comment %{
    "author_association" => "NONE",
    "body" => ":warning: @SimonLab, the pull request has a **merge conflict**.\nPlease resolve the conflict and reassign when ready :+1:\nThanks!\n\nAny questions, complaints, feedback, contributions?\n[![Discuss](https://img.shields.io/badge/discuss-with%20us-brightgreen.svg?style=flat)](https://github.com/dwyl/dwylbot/issues \"Discuss your ideas/suggestions with us!\")\nIf you prefer, you can also send us anonymous feedback: https://dwyl-feedback.herokuapp.com/feedback/new\n",
    "created_at" => "2017-06-26T13:21:23Z",
    "html_url" => "https://github.com/SimonLab/github_app/pull/23#issuecomment-311057291",
    "id" => 311057291,
    "issue_url" => "https://api.github.com/repos/SimonLab/github_app/issues/18",
    "performed_via_github_app" => nil,
    "updated_at" => "2017-06-26T13:21:23Z",
    "url" => "https://api.github.com/repos/SimonLab/github_app/issues/comments/311057291",
    "user" => %{
      "avatar_url" => "https://avatars2.githubusercontent.com/in/2666?v=4",
      "events_url" => "https://api.github.com/users/simonlabapp%5Bbot%5D/events{/privacy}",
      "followers_url" => "https://api.github.com/users/simonlabapp%5Bbot%5D/followers",
      "following_url" => "https://api.github.com/users/simonlabapp%5Bbot%5D/following{/other_user}",
      "gists_url" => "https://api.github.com/users/simonlabapp%5Bbot%5D/gists{/gist_id}",
      "gravatar_id" => "",
      "html_url" => "https://github.com/apps/simonlabapp",
      "id" => 29067442,
      "login" => "simonlabapp[bot]",
      "organizations_url" => "https://api.github.com/users/simonlabapp%5Bbot%5D/orgs",
    }
  }
  @issue %{
    "assignee" => nil,
    "assignees" => [],
    "author_association" => "OWNER",
    "body" => "a",
    "closed_at" => "2017-06-16T14:55:39Z",
    "comments" => [@comment],
    "comments_url" => "https://api.github.com/repos/SimonLab/github_app/issues/18/comments",
    "created_at" => "2017-06-16T14:52:18Z",
    "events_url" => "https://api.github.com/repos/SimonLab/github_app/issues/18/events",
    "html_url" => "https://github.com/SimonLab/github_app/pull/18",
    "id" => 236506221,
    "labels" => [],
    "labels_url" => "https://api.github.com/repos/SimonLab/github_app/issues/18/labels{/name}",
    "locked" => false,
    "milestone" => nil,
    "number" => 18,
    "performed_via_github_app" => nil,
    "repository_url" => "https://api.github.com/repos/SimonLab/github_app",
    "state" => "closed",
    "title" => "aaaaaaa",
    "updated_at" => "2017-06-16T14:55:39Z",
    "url" => "https://api.github.com/repos/SimonLab/github_app/issues/18",
    "user" => %{
      "login" => "bob",
      "avatar_url" => "https://avatars2.githubusercontent.com/u/6057298?v=4",
      "events_url" => "https://api.github.com/users/SimonLab/events{/privacy}",
    }
  }

  def get_installation_token(_installation_id) do
    "token_installation_1234"
  end

  def get_issues(_token, _payload, _page, _issues) do
    [@issue]
  end

  def get_comments(_token, _repo, _page, _comments) do
    [@comment]
  end

  def add_meta_table(repo_name, issue_id, content, token) do
    :ok
  end
end
