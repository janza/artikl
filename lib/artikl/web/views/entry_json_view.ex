defmodule Artikl.Web.EntryJSONView do
  use Artikl.Web, :view
  alias Artikl.Web.EntryJSONView

  def render("index.json", %{entires: entires}) do
    %{data: render_many(entires, EntryJSONView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, EntryJSONView, "entry.json")}
  end

  def render("entry.json", %{entry_json: entry}) do
    %{id: entry.id,
      title: entry.title,
      url: entry.url,
      content: entry.content,
      html: entry.html,
      is_read: entry.is_read}
  end
end
