defmodule AppWeb.AWS.S3 do
  @moduledoc """
  wrapper functions for saving data to aws s3
  """
  alias ExAws.S3


  def saveToS3(payload) do
    # Take the payload and then strip the content out of it
    IO.inspect payload["issue"]["body"]
    # Save the body into s3
    s3Bucket = System.get_env("S3_BUCKET_NAME")
    # Code taken from the ExAws repo apart from the inspect
    S3.list_objects(s3Bucket) |> ExAws.request |> IO.inspect
  end

end
