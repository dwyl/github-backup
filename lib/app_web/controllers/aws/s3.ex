defmodule AppWeb.AWS.S3 do
  @moduledoc """
  wrapper functions for saving data to aws s3
  """
  alias ExAws.S3
  @s3_bucket System.get_env("S3_BUCKET_NAME")
  @s3_region "eu-west-2"

  def save_comment(issue_id, comment) do
    @s3_bucket
    |> S3.put_object("#{issue_id}.json", comment)
    |> ExAws.request(region: @s3_region)
  end

  def get_issue(issue_id) do
    @s3_bucket
    |> S3.get_object("#{issue_id}.json")
    |> ExAws.request(region: @s3_region)
  end

end
