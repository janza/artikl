defmodule Artikl.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :url, :string
      add :title, :string
      add :read, :boolean, default: false, null: false

      timestamps()
    end

  end
end
