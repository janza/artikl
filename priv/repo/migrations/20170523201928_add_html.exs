defmodule Artikl.Repo.Migrations.AddHtml do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :html, :text, null: true
    end
  end
end
