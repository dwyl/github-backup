defmodule AppWeb.Helpers.View do
  @moduledoc """
  Helper functions for views to use
  """
  import Timex

  use Phoenix.HTML

  def format_date(date) do
    date
    |> Timex.from_now
  end

  def tidyISODate(iso_date) do
    iso_date
    |> String.replace("T", " ")
    |> String.split(".")
    |> List.first
  end

  def display_markdown(text) do
    text
    |> Earmark.as_html!
    |> raw
  end

end
