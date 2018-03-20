defmodule AppWeb.Helpers.ViewTest do
  use AppWeb.ConnCase

  @shared_classes "ml3 mv3 tl w-100 ba gb-b--light-gray br2 comment relative"
  @comment_text "- [ ] Unchecked - [ ]\r\n- [x] Checked"
  @html_comment "<p> <input type='checkbox' disabled> Unchecked - [ ]<br/> <input type='checkbox' checked='checked' disabled> Checked</p>\n"


  test "style_comments returns correct classes" do
    assert AppWeb.Helpers.View.style_comments(0) == @shared_classes
    assert AppWeb.Helpers.View.style_comments(1) == @shared_classes <> " bg-moon-gray"
  end

  test "display_markdown returns the correct string with html checkboxes" do
    {:safe, converted_comment_text} = AppWeb.Helpers.View.display_markdown(@comment_text)
    assert converted_comment_text == @html_comment
  end
end
