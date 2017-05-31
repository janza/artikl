defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:artikl)

    path = Application.app_dir(:artikl, "priv/repo/migrations")

    Ecto.Migrator.run(Artikl.Repo, path, :up, all: true)
  end
end
