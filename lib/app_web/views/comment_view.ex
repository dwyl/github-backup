defmodule AppWeb.CommentView do
  use AppWeb, :view

  def format_date(date) do
    NaiveDateTime.truncate(date, :second)
  end

end
