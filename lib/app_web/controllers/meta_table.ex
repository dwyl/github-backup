defmodule AppWeb.MetaTable do

  def get_meta_table(issue_id) do
    count = AppWeb.Endpoint.url <> "/edit-count/#{issue_id}"
    history = AppWeb.Endpoint.url <> "/issues/#{issue_id}"
    """
    | Edits | View issue history |
    |-|-|
    |[![Edit Count](#{count})](#{count}) | **View History:** [#{history}](#{history})|
    """
  end
end
