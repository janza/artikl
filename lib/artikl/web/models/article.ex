defmodule Artikl.Article do
  use Artikl.Web, :model

  schema "articles" do
    field :url, :string
    field :title, :string, default: "title"
    field :content, :string
    field :html, :string
    field :read, :boolean, default: false

    timestamps()
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :read, :content, :html])
    |> validate_required([:url, :read])
    |> validate_url(:url, message: "URL is not valid")
  end
end
