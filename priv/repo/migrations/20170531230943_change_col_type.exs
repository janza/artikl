defmodule Artikl.Repo.Migrations.ChangeColType do
  use Ecto.Migration

  def change do
    alter table(:article_entires) do
      modify :title, :text
      modify :html, :text
      modify :content, :text
    end
  end
end
