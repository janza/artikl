defmodule Artikl.Article.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Artikl.Article.Entry


  schema "article_entires" do
    field :content, :string
    field :html, :string
    field :is_read, :boolean, default: false
    field :title, :string
    field :url, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:title, :url, :content, :html, :is_read])
    |> validate_required([:url, :is_read])
    |> validate_url(:url)
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end
end

defimpl Phoenix.Param, for: Artikl.Article.Entry do
  def to_param(%{slug: slug, id: id}) do
    "#{slug}_#{id}"
  end
end
