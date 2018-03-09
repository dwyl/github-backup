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

  def get_issues(token, repo, page, issues) do
    data = "#{@github_root}/repos/#{repo}/issues?state=all&per_page=100&page=#{page}"
    |> HTTPoison.get!(header(token), [])

    body = PP.parse!(Map.fetch!(data, :body))
    issues = issues ++ body

    if last_page?(Map.fetch!(data, :headers)) do
      issues
    else
      get_issues(token, repo, page + 1, issues)
    end
  end

  def get_comments(token, repo, page, comments) do
    data = "#{@github_root}/repos/#{repo}/issues/comments?per_page=100&page=#{page}"
    |> HTTPoison.get!(header(token), [])

    body =  Map.fetch!(data, :body)
            |> PP.parse!
    comments = comments ++ body

    if last_page?(Map.fetch!(data, :headers)) do
      comments
    else
      get_comments(token, repo, page + 1, comments)
    end
  end

  defp last_page?(headers) do
    links_header = Map.get(Enum.into(headers, %{}), "Link")
    if links_header do
      links_header
      |> String.split(",")
      |> Enum.map(fn l ->
        regex = Regex.named_captures(~r/<(?<link>.*)>;\s*rel=\"(?<rel>.*)\"/, l)
        regex
        |> case do
          %{"link" => _link, "rel" => "next"} -> true
          _ -> nil
        end
      end)
      |> Enum.filter(&(not is_nil(&1)))
      |> Enum.empty?()
    else
      true
    end
  end

end
