defmodule Artikl.Web.ArticleController do
  use Artikl.Web, :controller

  alias Artikl.Article

  require Logger

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    if changeset.valid? do
      Logger.info "Summarizing url: #{changeset.changes.url}"
      summary = Readability.summarize(changeset.changes.url)
      changeset = Ecto.Changeset.change(changeset, %{
        content: summary.article_text,
        html: summary.article_html,
        title: summary.title,
      })

      case Repo.insert(changeset) do
        {:ok, article} ->
          conn
          |> redirect(to: article_path(conn, :show, article))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    render(conn, "show.html", article: article)
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    Repo.delete!(article)

    conn
    |> redirect(to: article_path(conn, :index))
  end
end
