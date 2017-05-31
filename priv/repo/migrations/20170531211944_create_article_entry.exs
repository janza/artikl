defmodule Artikl.Repo.Migrations.CreateArtikl.Article.Entry do
  use Ecto.Migration

  def change do
    create table(:article_entires) do
      add :title, :string
      add :url, :string
      add :content, :string
      add :html, :string
      add :is_read, :boolean, default: false, null: false

      timestamps()
    end

  end
end
