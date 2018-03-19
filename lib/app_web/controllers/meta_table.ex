defmodule AppWeb.MetaTable do
alias AppWeb.Endpoint

  def get_meta_table(issue_id) do
    count = Endpoint.url <> "/edit-count/#{issue_id}"
    history = Endpoint.url <> "/issues/#{issue_id}"
    """
    <!-- do not edit below this line to preserve issue history -->
    | Edits | View issue history |
    |-|-|
    |[![Edit Count](#{count})](#{count}) | **View History:** [#{history}](#{history})|
    """
  end
end
