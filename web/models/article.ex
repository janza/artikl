defmodule Artikl.Article do
  use Artikl.Web, :model

  schema "articles" do
    field :url, :string
    field :title, :string, default: 'title'
    field :content, :string
    field :read, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :read])
    |> validate_required([:url, :read])
  end
end
