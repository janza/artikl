defmodule Artikl.Repo.Migrations.AddSlug do
  use Ecto.Migration

  def change do
    alter table(:article_entires) do
      add :slug, :string
    end
  end
end
