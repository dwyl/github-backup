defmodule AppWeb.AWS.S3 do
  @moduledoc """
  wrapper functions for saving data to aws s3
  """
  alias ExAws.S3

  def save_comment(issue_id, comment) do
    s3Bucket = System.get_env("S3_BUCKET_NAME")
    S3.put_object(s3Bucket, "#{issue_id}.json", comment)
    |> ExAws.request(region: "eu-west-2")
  end

end
