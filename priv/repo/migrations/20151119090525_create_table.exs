defmodule SampleRakutenGenre.Repo.Migrations.CreateTable do
  use Ecto.Migration

 def change do
   create table(:rakuten) do
     add :genre_id, :integer
     add :genre_name, :string
     add :genre_level, :integer

     timestamps
   end

   create unique_index :rakuten, [:genre_id]
 end
end
