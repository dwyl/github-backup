defmodule AppWeb.Helpers.View do
  @moduledoc """
  Helper functions for views to use
  """
  use Phoenix.HTML
  import Timex

  @shared_classes "ml3 mv3 tl w-100 ba gh-b--light-gray br2 comment relative"

  def format_date(date) do
    date
    |> Timex.from_now
  end

# Function not in use, but will be when implementing: https://git.io/vxU7b
  # def tidyISODate(iso_date) do
  #   iso_date
  #   |> String.replace("T", " ")
  #   |> String.split(".")
  #   |> List.first
  # end

  def style_comments(version_index) do
    case version_index do
      0 ->
        @shared_classes
      _ ->
        @shared_classes <> " bg-moon-gray"
    end
  end

  def display_markdown(text) do
    text
    |> Earmark.as_html!
    |> raw
  end

end
