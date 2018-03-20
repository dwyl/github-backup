defmodule AppWeb.Helpers.View do
  @moduledoc """
  Helper functions for views to use
  """
  use Phoenix.HTML

  @shared_classes "ml3 mv3 tl w-100 ba gb-b--light-gray br2 comment relative"
  @checked_box "<input type=\'checkbox\' checked=\'checked\' disabled>"
  @unchecked_box "<input type=\'checkbox\' disabled>"
  @regex_unchecked ~r/^[-,*,+] \[\s\]|\r\n[-,*,+] \[\s\]/
  @regex_unchecked_inc_text ~r/^[-,*,+]\s\[\s\]\s\S+|\r\n[-,*,+]\s\[\s\]\s\S+/
  @regex_checked ~r/\r\n[-,*,+] \[[X,x]\]|^[-,*,+] \[[X,x]\]/
  @regex_checked_inc_text ~r/\r\n[-,*,+] \[[X,x]\] \S+|^[-,*,+] \[[X,x]\] \S+/

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
    |> sanitize_html
    |> detect_checkboxes
    |> Earmark.as_html!(%Earmark.Options{breaks: true})
    |> raw
  end

  def sanitize_html(html_comment) do
    HtmlSanitizeEx.basic_html(html_comment)
  end

  def detect_checkboxes(text) do
    text
    |> replace_checked_boxes
    |> replace_unchecked_boxes
  end

  def replace_checked_boxes(text) do
    if String.match?(text, @regex_checked_inc_text) do
      String.replace(text, @regex_checked, "\r\n " <> @checked_box)
    else
      text
    end
  end

  def replace_unchecked_boxes(text) do
    if String.match?(text, @regex_unchecked_inc_text) do
      String.replace(text, @regex_unchecked, "\r\n " <> @unchecked_box)
    else
      text
    end
  end
end
