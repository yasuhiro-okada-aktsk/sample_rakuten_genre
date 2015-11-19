defmodule SampleRakutenGenre.RakutenGenre do
  use Ecto.Model

  import Ecto.Changeset
  import Ecto.Query, only: [from: 1, from: 2]

  require Logger

  schema "rakuten_genres" do
    field :genre_id, :integer
    field :genre_name, :string
    field :genre_level, :integer
    field :genre_parent, :integer
    field :completed, :integer

    timestamps
  end

  def changeset_insert(model, params, parent) do
    params = %{genre_id: params["genreId"], genre_name: params["genreName"],
              genre_level: params["genreLevel"], genre_parent: parent, completed: 0}

    model
    |> cast(params, ~w(genre_id genre_name genre_level genre_parent completed), ~w())
    |> unique_constraint(:genre_id)
  end
end
