defmodule SampleRakutenGenre.Repo.Migrations.AlterTable do
  use Ecto.Migration

  def change do
    rename table(:rakuten), to: table(:rakuten_genres)
  end
end
