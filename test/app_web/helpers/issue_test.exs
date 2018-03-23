defmodule AppWeb.IssueHelperTest do
  use AppWeb.ConnCase
  alias App.Helpers.IssueHelper

  test "filter issue (exclue PRs)" do
    issues = [
      %{issue_id: 1, pull_request: false},
      %{issue_id: 2, pull_request: true}
    ]

    filtered_issues = IssueHelper.get_issues(issues)
    assert length(filtered_issues) == 1
    assert List.first(filtered_issues) == %{issue_id: 1, pull_request: false}
  end

  test "generate map of comments" do
    issues = [
      %{issue_id: 1, comments: [
        %{comment_id: "1", comment: "comment 1"},
        %{comment_id: "2", comment: "comment 2"}
        ]},
      %{issue_id: 2, comments: [
        %{comment_id: "3", comment: "comment 3"},
        %{comment_id: "4", comment: "comment 4"}
        ]}
    ]
    expected = %{
      "1" => "comment 1",
      "2" => "comment 2",
      "3" => "comment 3",
      "4" => "comment 4"
    }

    assert IssueHelper.get_map_comments(issues) == expected
  end

  test "create comment from issue description" do
    issues = [
      %{
        issue_id: "1",
        issue_author: %{id: 1},
        description: "new issue",
        inserted_at: "2018",
        updated_at: "2018",
        comments: []
      }
    ]
    expected = [
      %{
        issue_id: "1",
        issue_author: %{id: 1},
        description: "new issue",
        inserted_at: "2018",
        updated_at: "2018",
        comments: [
          %{
            comment_id: "1_1",
            comment: "new issue",
            inserted_at: "2018",
            updated_at: "2018",
            versions: [
              %{
                author: 1,
                inserted_at: "2018",
                updated_at: "2018"
                }
              ]
          }
        ]
      }
    ]

    assert IssueHelper.issues_as_comments(issues) == expected
  end

  test "generate s3 content file" do
    issue = %{
                issue_id: "1",
                issue_author: "me",
                description: "new issue",
                comments: [
                  %{
                    comment_id: "1_1",
                    comment: "new issue",
                    versions: [%{id: 1, author: "me"}]
                  },
                  %{
                    comment_id: "2",
                    versions: [%{id: 2, author: "me"}]
                  }
                ]
              }
    comments = %{"1_1" => "comment 1", "2" => "comment 2"}
    expected = %{1 => "comment 1", 2 => "comment 2"}
    assert IssueHelper.get_s3_content(issue, comments) == expected
  end

  test "attach comments to issues" do
    comments = [
      %{"issue_url" => "url1", "comment_id" => 1},
      %{"issue_url" => "url1", "comment_id" => 2},
      %{"issue_url" => "url42", "comment_id" => 42}
    ]
    issues = [%{"url" => "url1"}, %{"url" => "url2"}, %{"url" => "url42"}]
    expected = [
      %{"url" => "url1", "comments" => [
        %{"comment_id" => 1, "issue_url" => "url1"},
        %{"comment_id" => 2, "issue_url" => "url1"}]},
      %{"url" => "url2", "comments" => []},
      %{"url" => "url42", "comments" => [
        %{"comment_id" => 42, "issue_url" => "url42"}
        ]}
    ]

    assert IssueHelper.attach_comments(issues, comments) == expected
  end
end
