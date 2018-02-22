defmodule AppWeb.GithubAPI.HTTPClient do
  @moduledoc """
  wrapper functions for the API Github App API
  """
  alias Poison.Parser, as: PP
  alias JOSE.JWK, as: JJ
  import Joken

  @media_type "application/vnd.github.machine-man-preview+json"
  @github_root "https://api.github.com"

  defp header(token) do
    ["Authorization": "token #{token}", "Accept": @media_type]
  end

  defp headerBearer(token) do
    ["Authorization": "Bearer #{token}", "Accept": @media_type]
  end

  def get_installation_token(installation_id) do
    private_key = System.get_env("PRIVATE_KEY")
    github_app_id = System.get_env("GITHUB_APP_ID")
    key = JJ.from_pem(private_key)
    my_token = %{
      iss: github_app_id,
      iat: DateTime.utc_now |> DateTime.to_unix,
      exp: (DateTime.utc_now |> DateTime.to_unix) + 100
    }
    |> token()
    |> sign(rs256(key))
    |> get_compact()

    "#{@github_root}/installations/#{installation_id}/access_tokens"
    |> HTTPoison.post!([], headerBearer(my_token))
    |> Map.fetch!(:body)
    |> PP.parse!
    |> Map.get("token")
  end

  defp get(token, url) do
    url
    |> HTTPoison.get!(header(token), [])
    |> Map.fetch!(:body)
    |> PP.parse!()
  end

  def get_issues(token, payload) do
    "#{@github_root}/repos/#{payload["repository"]["full_name"]}/issues"
    |> HTTPoison.get!(header(token), [])
    |> Map.fetch!(:body)
    |> PP.parse!
  end

  def get_comments(token, payload) do
    "#{@github_root}/repos/#{payload["repository"]["full_name"]}/issues/comments"
    |> HTTPoison.get!(header(token), [])
    |> Map.fetch!(:body)
    |> PP.parse!
  end

  # def get_pull_requests(token, payload, rule_name) do
  #   "#{@github_root}/repos/#{payload["repository"]["full_name"]}/pulls"
  #   |> HTTPoison.get!(header(token), [])
  #   |> Map.fetch!(:body)
  #   |> PP.parse!
  #   |> Enum.map(fn(pr) ->
  #     urls = %{
  #       "issue" => pr["issue_url"],
  #       "pull_request" => pr["url"]
  #     }
  #     get_data(token, urls, rule_name)
  #   end)
  # end

end
