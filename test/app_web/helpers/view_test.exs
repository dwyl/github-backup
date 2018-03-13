defmodule AppWeb.Helpers.ViewTest do
  use AppWeb.ConnCase

  @shared_classes "ml3 mv3 tl w-100 ba gh-b--light-gray br2 comment relative"

  test "style_comments returns correct classes" do
    assert AppWeb.Helpers.View.style_comments(0) == @shared_classes
    assert AppWeb.Helpers.View.style_comments(1) == @shared_classes <> " bg-moon-gray"
  end
end
