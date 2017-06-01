defmodule Artikl.Web.EntryView do
  use Artikl.Web, :view
  alias Artikl.Web.EntryView

  def render("index.json", %{entires: entires}) do
    %{data: render_many(entires, EntryView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, EntryView, "entry.json")}
  end

  def render("entry.json", %{entry: entry}) do
    %{id: entry.id,
      title: entry.title,
      url: entry.url,
      content: entry.content,
      html: entry.html,
      is_read: entry.is_read}
  end
end
