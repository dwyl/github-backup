defmodule AppWeb.CommentView do
  use AppWeb, :view

  def format_date(date) do
    date
    |> NaiveDateTime.to_iso8601
    |> tidyISODate
  end

  def tidyISODate(iso_date) do
    iso_date
    |> String.replace("T", " ")
    |> String.split(".")
    |> List.first
  end

end
