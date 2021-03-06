defmodule Artikl.Web.EntryJSONController do
  use Artikl.Web, :controller

  alias Artikl.Article
  alias Artikl.Article.Entry

  action_fallback Artikl.Web.FallbackController

  def index(conn, _params) do
    entires = Article.list_entires()
    render(conn, "index.json", entires: entires)
  end

  def create(conn, %{"entry" => entry_params}) do
    with {:ok, %Entry{} = entry} <- Article.create_entry(entry_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", entry_path(conn, :show, entry))
      |> render("show.json", entry: entry)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Article.get_entry!(id)
    render(conn, "show.json", entry: entry)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Article.get_entry!(id)

    with {:ok, %Entry{} = entry} <- Article.update_entry(entry, entry_params) do
      render(conn, "show.json", entry: entry)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Article.get_entry!(id)
    with {:ok, %Entry{}} <- Article.delete_entry(entry) do
      send_resp(conn, :no_content, "")
    end
  end
end
