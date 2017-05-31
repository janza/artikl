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
    Repo.all(Entry)
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.
  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.
  """
  def create_entry(attrs \\ %{}) do
    entry = %Entry{}
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
      summary = Readability.summarize(changeset.changes.url)
      Ecto.Changeset.change(changeset, %{
        content: summary.article_text,
        html: summary.article_html,
        title: summary.title,
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
