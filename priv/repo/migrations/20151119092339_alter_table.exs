defmodule SampleRakutenGenre.Repo.Migrations.AlterTable do
  use Ecto.Migration

  def change do
    alter table(:rakuten_genres) do
      add :completed, :integer
    end
  end
end
