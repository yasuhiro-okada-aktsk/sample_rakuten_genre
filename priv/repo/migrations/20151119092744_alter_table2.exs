defmodule SampleRakutenGenre.Repo.Migrations.AlterTable2 do
  use Ecto.Migration

  def change do
    alter table(:rakuten_genres) do
      add :genre_parent, :integer
    end
  end
end
