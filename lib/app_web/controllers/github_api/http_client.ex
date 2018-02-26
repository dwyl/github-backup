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
    data = "#{@github_root}/repos/#{payload["repository"]["full_name"]}/issues?state=all&per_page=5"
    |> HTTPoison.get!(header(token), [])

    # headers = Map.fetch!(data, :headers) |> PP.parse!() |> IO.inspect()
    nl = last_page(Map.fetch!(data, :headers))
    IO.inspect nl
    body = Map.fetch!(data, :body) |> PP.parse!()
  end

  # def get_issues(token, payload) do
  #   # get number of pages
  #   # get issue
  # end
  # def get_issues(token, payload, page) do
  #   # get the issue for the page
  # end

  def get_comments(token, payload) do
    "#{@github_root}/repos/#{payload["repository"]["full_name"]}/issues/comments"
    |> HTTPoison.get!(header(token), [])
    |> Map.fetch!(:body)
    |> PP.parse!
  end

  defp next_link(headers) do
    for {"Link", link_header} <- headers, links <- String.split(link_header, ",") do
      Regex.named_captures(~r/<(?<link>.*)>;\s*rel=\"(?<rel>.*)\"/, links)
      |> case do
        %{"link" => link, "rel" => "next"} -> link
        _ -> nil
      end
    end
    |> Enum.filter(&(not is_nil(&1)))
    |> List.first
  end

  defp last_page(headers) do
    links = for {"Link", link_header} <- headers, links <- String.split(link_header, ",") do
      Regex.named_captures(~r/<(?<link>.*)>;\s*rel=\"(?<rel>.*)\"/, links)
      |> case do
        %{"link" => link, "rel" => "last"} -> link
        _ -> nil
      end
    end
    IO.inspect "***********"
    IO.inspect links
    IO.inspect "***********"
    last_link = links
    |> Enum.filter(&(not is_nil(&1)))
    |>List.first

    IO.inspect last_link
    Regex.named_captures(~r/&page=(?<page>\d.)/, last_link)
  end

end
