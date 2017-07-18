defmodule Artikl.Article do
  @moduledoc """
  The boundary for the Article system.
  """

  import Ecto.Query, warn: false
  alias Artikl.Repo

  alias Artikl.Article.Entry

  @doc """
  Returns the list of entires.
  """
  def list_entires do
    Repo.all(Entry |> order_by(desc: :id))
  end

  @doc """
  Gets a single entry for a specified slug.

  Raises `Ecto.NoResultsError` if the Entry does not exist.
  """
  def get_entry!(slugWithId) do
    Repo.get!(Entry, id_from_slug(slugWithId))
  end

  @doc """
  Extract id from slug.

  Raises `Ecto.NoResultsError` if the Entry does not exist.
  """
  def id_from_slug(slug_with_id) do
    slug_with_id
    |> String.split("_")
    |> List.last
  end


  @doc """
  Creates a entry.
  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> sync_with_url
    |> add_slug
    |> Repo.insert()
  end

  @doc """
  Updates changeset with data retrieved from remote source.
  """
  def sync_with_url(changeset) do
    if changeset.valid? do
      %{status_code: _, body: raw_html} = HTTPoison.get!(
        changeset.changes.url,
        [{"user-agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.7 Safari/537.36"}],
        [follow_redirect: true, force_redirect: true, hackney: [force_redirect: true]])
      article = Readability.article(raw_html)
      Ecto.Changeset.change(changeset, %{
        content: Readability.readable_text(article),
        html: Readability.readable_html(article),
        title: Readability.title(raw_html)
      })
    else
      changeset
    end
  end

  @doc """
  Updates a entry.
  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> sync_with_url
    |> add_slug
    |> Repo.update()
  end

  @doc """
  Deletes a Entry.
  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.
  """
  def change_entry(%Entry{} = entry) do
    Entry.changeset(entry, %{})
  end

  def add_slug(changeset) do
    Ecto.Changeset.change(changeset, %{
      slug: slugified_title(changeset.changes.title)
    })
  end

  def slugified_title(title) do
    title
    |> String.downcase
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end
end
