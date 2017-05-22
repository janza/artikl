defmodule Artikl.Repo.Migrations.AddContent do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :content, :text, null: true
      modify :title, :string, default: "title"
    end
  end
end
